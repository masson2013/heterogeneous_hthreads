---------------------------------------------------------------------------
--
--  Title: Hardware Thread User Logic Exit Thread
--  To be used as a place holder, and size estimate for HWTI
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_misc.all;

library Unisim;
use Unisim.all;

---------------------------------------------------------------------------
-- Port declarations
---------------------------------------------------------------------------
-- Definition of Ports:
--
--  Misc. Signals
--    clock
--
--  HWTI to HWTUL interconnect
--    intrfc2thrd_address      32 bits   memory    
--    intrfc2thrd_value        32 bits   memory    function
--    intrfc2thrd_function     16 bits                       control
--    intrfc2thrd_goWait        1 bits                       control
--
--  HWTUL to HWTI interconnect
--    thrd2intrfc_address      32 bits   memory
--    thrd2intrfc_value        32 bits   memory    function
--    thrd2intrfc_function     16 bits             function
--    thrd2intrfc_opcode        6 bits   memory    function
--


---------------------------------------------------------------------------
-- Thread Manager Entity section
---------------------------------------------------------------------------

entity user_logic_hwtul is
  port (
    clock : in std_logic;
    intrfc2thrd_address : in std_logic_vector(0 to 31);
    intrfc2thrd_value : in std_logic_vector(0 to 31);
    intrfc2thrd_function : in std_logic_vector(0 to 15);
    intrfc2thrd_goWait : in std_logic;

    thrd2intrfc_address : out std_logic_vector(0 to 31);
    thrd2intrfc_value : out std_logic_vector(0 to 31);
    thrd2intrfc_function : out std_logic_vector(0 to 15);
    thrd2intrfc_opcode : out std_logic_vector(0 to 5)
  );
end entity user_logic_hwtul;

---------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------

architecture IMP of user_logic_hwtul is

---------------------------------------------------------------------------
-- Signal declarations
---------------------------------------------------------------------------

  type state_machine is (
    FUNCTION_RESET,
    FUNCTION_USER_SELECT,
    FUNCTION_START,
	STATE_1,
	STATE_2,
	STATE_3,
	STATE_4,
	STATE_5,
	LOOP_1,
	LOOP_2,
	LOOP_3,
	LOOP_4,
	MEMCPY_1,
	MEMCPY_2,
	MEMCPY_3,
	MEMCPY_4,
    CALL_EXIT,
    WAIT_STATE,
    ERROR_STATE);

  -- Function definitions
  constant U_FUNCTION_RESET                      : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                       : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT                : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                      : std_logic_vector(0 to 15) := x"0003";
  constant U_CALL_EXIT                           : std_logic_vector(0 to 15) := x"0004";
  -- Range 0003 to 7999 reserved for user logic's state machine
  -- Range 8000 to 9999 reserved for system calls
  -- constant FUNCTION_HTHREAD_ATTR_INIT          : std_logic_vector(0 to 15) := x"8000";
  -- constant FUNCTION_HTHREAD_ATTR_DESTROY       : std_logic_vector(0 to 15) := x"8001";
  -- constant FUNCTION_HTHREAD_CREATE             : std_logic_vector(0 to 15) := x"8010";
  -- constant FUNCTION_HTHREAD_JOIN               : std_logic_vector(0 to 15) := x"8011";
  constant FUNCTION_HTHREAD_SELF               : std_logic_vector(0 to 15) := x"8012";
  constant FUNCTION_HTHREAD_YIELD              : std_logic_vector(0 to 15) := x"8013";
  constant FUNCTION_HTHREAD_EQUAL              : std_logic_vector(0 to 15) := x"8014";
  constant FUNCTION_HTHREAD_EXIT               : std_logic_vector(0 to 15) := x"8015";
  constant FUNCTION_HTHREAD_EXIT_ERROR         : std_logic_vector(0 to 15) := x"8016";
  constant FUNCTION_HTHREAD_MUTEXATTR_INIT     : std_logic_vector(0 to 15) := x"8020";
  constant FUNCTION_HTHREAD_MUTEXATTR_DESTROY  : std_logic_vector(0 to 15) := x"8021";
  constant FUNCTION_HTHREAD_MUTEXATTR_SETNUM   : std_logic_vector(0 to 15) := x"8022";
  constant FUNCTION_HTHREAD_MUTEXATTR_GETNUM   : std_logic_vector(0 to 15) := x"8023";
  constant FUNCTION_HTHREAD_MUTEX_INIT         : std_logic_vector(0 to 15) := x"8030";
  constant FUNCTION_HTHREAD_MUTEX_DESTROY      : std_logic_vector(0 to 15) := x"8031";
  constant FUNCTION_HTHREAD_MUTEX_LOCK         : std_logic_vector(0 to 15) := x"8032";
  constant FUNCTION_HTHREAD_MUTEX_UNLOCK       : std_logic_vector(0 to 15) := x"8033";
  constant FUNCTION_HTHREAD_MUTEX_TRYLOCK      : std_logic_vector(0 to 15) := x"8034";
  constant FUNCTION_HTHREAD_CONDATTR_INIT      : std_logic_vector(0 to 15) := x"8040";
  constant FUNCTION_HTHREAD_CONDATTR_DESTROY   : std_logic_vector(0 to 15) := x"8041";
  constant FUNCTION_HTHREAD_CONDATTR_SETNUM    : std_logic_vector(0 to 15) := x"8042";
  constant FUNCTION_HTHREAD_CONDATTR_GETNUM    : std_logic_vector(0 to 15) := x"8043";
  constant FUNCTION_HTHREAD_COND_INIT          : std_logic_vector(0 to 15) := x"8050";
  constant FUNCTION_HTHREAD_COND_DESTROY       : std_logic_vector(0 to 15) := x"8051";
  constant FUNCTION_HTHREAD_COND_SIGNAL        : std_logic_vector(0 to 15) := x"8052";
  constant FUNCTION_HTHREAD_COND_BROADCAST     : std_logic_vector(0 to 15) := x"8053";
  constant FUNCTION_HTHREAD_COND_WAIT          : std_logic_vector(0 to 15) := x"8054";
  -- Ranged A000 to FFFF reserved for supported library calls
  constant FUNCTION_MALLOC                     : std_logic_vector(0 to 15) := x"A000";
  constant FUNCTION_CALLOC                     : std_logic_vector(0 to 15) := x"A001";
  constant FUNCTION_FREE                       : std_logic_vector(0 to 15) := x"A002";
  constant FUNCTION_MEMCPY                     : std_logic_vector(0 to 15) := x"A100";

  -- user_opcode Constants
  constant OPCODE_NOOP                         : std_logic_vector(0 to 5) := "000000";
  -- Memory sub-interface specific opcodes
  constant OPCODE_LOAD                         : std_logic_vector(0 to 5) := "000001";
  constant OPCODE_STORE                        : std_logic_vector(0 to 5) := "000010";
  constant OPCODE_DECLARE                      : std_logic_vector(0 to 5) := "000011";
  constant OPCODE_READ                         : std_logic_vector(0 to 5) := "000100";
  constant OPCODE_WRITE                        : std_logic_vector(0 to 5) := "000101";
  constant OPCODE_ADDRESS                      : std_logic_vector(0 to 5) := "000110";
  -- Function sub-interface specific opcodes
  constant OPCODE_PUSH                         : std_logic_vector(0 to 5) := "010000";
  constant OPCODE_POP                          : std_logic_vector(0 to 5) := "010001";
  constant OPCODE_CALL                         : std_logic_vector(0 to 5) := "010010";
  constant OPCODE_RETURN                       : std_logic_vector(0 to 5) := "010011";

  constant Z32 : std_logic_vector(0 to 31) := (others => '0');

  signal current_state, next_state : state_machine := FUNCTION_RESET;
  signal return_state, return_state_next: state_machine := FUNCTION_RESET;

  signal argumentPtr, argumentPtr_next : std_logic_vector(0 to 31);
  signal readPtr, readPtr_next : std_logic_vector(0 to 31);
  signal writePtr, writePtr_next : std_logic_vector(0 to 31);
  signal count, count_next : std_logic_vector(0 to 31);
  signal operation, operation_next : std_logic_vector(0 to 1);

  signal toUser_address : std_logic_vector(0 to 31);
  signal toUser_value : std_logic_vector(0 to 31);
  signal toUser_function : std_logic_vector(0 to 15);
  signal toUser_goWait : std_logic;

  -- misc constants

---------------------------------------------------------------------------
-- Begin architecture
---------------------------------------------------------------------------

begin -- architecture IMP

  HWTUL_STATE_PROCESS : process (clock, intrfc2thrd_goWait) is
  begin
    
    if (clock'event and (clock = '1')) then
	  toUser_address <= intrfc2thrd_address;
	  toUser_value <= intrfc2thrd_value;
	  toUser_function <= intrfc2thrd_function;
	  toUser_goWait <= intrfc2thrd_goWait;

	  return_state <= return_state_next;
	  argumentPtr <= argumentPtr_next;
	  readPtr <= readPtr_next;
	  writePtr <= writePtr_next;
	  count <= count_next;
	  operation <= operation_next;

      -- Find out if the HWTI is tell us what to do
      if (intrfc2thrd_goWait = '1') then
	    case intrfc2thrd_function is
		  -- Typically the HWTI will tell us to control our own destiny
		  when U_FUNCTION_USER_SELECT =>
            current_state <= next_state;

		  -- List all the functions the HWTI could tell us to run
		  when U_FUNCTION_RESET =>
		    current_state <= FUNCTION_RESET;
		  when U_FUNCTION_START =>
		    current_state <= FUNCTION_START;
		  when U_CALL_EXIT =>
		    current_state <= CALL_EXIT;

          -- If the HWTI tells us to do something we don't know, error
		  when OTHERS =>
		    current_state <= ERROR_STATE;
		end case;
	  else
	    current_state <= WAIT_STATE;
      end if;
    end if;
  end process HWTUL_STATE_PROCESS;


  HWTUL_STATE_MACHINE : process (clock) is
  begin

    -- Default register assignments
    thrd2intrfc_opcode <= OPCODE_NOOP; -- When issuing an OPCODE, must be a pulse
	thrd2intrfc_address <= Z32;
	thrd2intrfc_value <= Z32;
	thrd2intrfc_function <= U_FUNCTION_USER_SELECT;
	return_state_next <= return_state;
	next_state <= current_state;
	argumentPtr_next <= argumentPtr;
	readPtr_next <= readPtr;
	writePtr_next <= writePtr;
	count_next <= count;
	operation_next <= operation;

    -- The state machine
    case current_state is
      when FUNCTION_RESET =>
        --Set default values
        thrd2intrfc_opcode <= OPCODE_NOOP;
        thrd2intrfc_address <= Z32;
        thrd2intrfc_value <= Z32;
        thrd2intrfc_function <= U_FUNCTION_START;

      when FUNCTION_START =>
	    -- Read the argument pointer
		thrd2intrfc_opcode <= OPCODE_POP;
		thrd2intrfc_value <= x"00000000";
		next_state <= WAIT_STATE;
	    return_state_next <= STATE_1;

	  when STATE_1 =>
	    argumentPtr_next <= toUser_value;
		-- Read the address of the readPtr
		thrd2intrfc_opcode <= OPCODE_LOAD;
		thrd2intrfc_address <= toUser_value;
		next_state <= WAIT_STATE;
		return_state_next <= STATE_2;

	  when STATE_2 =>
	    readPtr_next <= toUser_value;
		-- Read the address of the writePtr
		thrd2intrfc_opcode <= OPCODE_LOAD;
		thrd2intrfc_address <= argumentPtr + 4;
		next_state <= WAIT_STATE;
		return_state_next <= STATE_3;

	  when STATE_3 =>
	    writePtr_next <= toUser_value;
		-- read the value of count (which is in bytes)
	    thrd2intrfc_opcode <= OPCODE_LOAD;
		thrd2intrfc_address <= argumentPtr + 8;
		next_state <= WAIT_STATE;
		return_state_next <= STATE_4;

	  when STATE_4 =>
	    count_next <= toUser_value;
		-- read the value of operation
	    thrd2intrfc_opcode <= OPCODE_LOAD;
		thrd2intrfc_address <= argumentPtr + 12;
		next_state <= WAIT_STATE;
		return_state_next <= STATE_5;

	  when STATE_5 =>
	    operation_next <= toUser_value(30 to 31);
		case toUser_value(30 to 31) is
		  when "11" => -- memcopy operation
		    next_state <= MEMCPY_1;
		  when others =>
		    next_state <= LOOP_1;
		end case;
	
	  when LOOP_1 =>
	    case count is
		  when x"00000000" =>
		    next_state <= CALL_EXIT;
		  when others =>
		    next_state <= LOOP_2;
		end case;

	  when LOOP_2 =>
        case operation is
		  when "00" => -- continuous write
		    thrd2intrfc_opcode <= OPCODE_STORE;
		    thrd2intrfc_address <= writePtr;
		    thrd2intrfc_value <= x"0000ABCD";
		    next_state <= WAIT_STATE;
		    return_state_next <= LOOP_4;
		  when "01" => -- continuous read
		    thrd2intrfc_opcode <= OPCODE_LOAD;
		    thrd2intrfc_address <= readPtr;
		    next_state <= WAIT_STATE;
		    return_state_next <= LOOP_4;
		  when others => -- continuous read, write
		    thrd2intrfc_opcode <= OPCODE_LOAD;
		    thrd2intrfc_address <= readPtr;
		    next_state <= WAIT_STATE;
		    return_state_next <= LOOP_3;
		end case;

	  when LOOP_3 =>
	    -- continuous read, write
		thrd2intrfc_opcode <= OPCODE_STORE;
		thrd2intrfc_address <= writePtr;
		thrd2intrfc_value <= toUser_value;
		next_state <= WAIT_STATE;
		return_state_next <= LOOP_4;
        
	  when LOOP_4 =>
	    -- decrement count, increment readPtr, writePtr
		count_next <= count - 4;
		readPtr_next <= readPtr + 4;
		writePtr_next <= writePtr + 4;
		next_state <= LOOP_1;
		    
      when MEMCPY_1 =>
	    -- call memcpy
		thrd2intrfc_opcode <= OPCODE_PUSH;
		thrd2intrfc_value <= count;
		next_state <= WAIT_STATE;
		return_state_next <= MEMCPY_2;

      when MEMCPY_2 =>
	    -- call memcpy
		thrd2intrfc_opcode <= OPCODE_PUSH;
		thrd2intrfc_value <= writePtr;
		next_state <= WAIT_STATE;
		return_state_next <= MEMCPY_3;

      when MEMCPY_3 =>
	    -- call memcpy
		thrd2intrfc_opcode <= OPCODE_PUSH;
		thrd2intrfc_value <= readPtr;
		next_state <= WAIT_STATE;
		return_state_next <= MEMCPY_4;

      when MEMCPY_4 =>
	    -- call memcpy
		thrd2intrfc_opcode <= OPCODE_CALL;
		thrd2intrfc_function <= FUNCTION_MEMCPY;
		thrd2intrfc_value <= Z32(0 to 15) & U_CALL_EXIT;
		next_state <= WAIT_STATE;

      when CALL_EXIT =>
        thrd2intrfc_opcode <= OPCODE_RETURN;
        thrd2intrfc_value <= Z32;
        next_state <= WAIT_STATE;
		return_state_next <= WAIT_STATE;

      when WAIT_STATE =>
        case toUser_goWait is
		  when '1' => --Here becasue HWTUL chose to be here for one clock cycle
		    next_state <= return_state;
		  when OTHERS => --ie '0', Here because HWTI is telling us to wait
		    next_state <= return_state;
        end case;

      when ERROR_STATE =>
        next_state <= ERROR_STATE;

      when others =>
        next_state <= ERROR_STATE;

    end case;
  end process HWTUL_STATE_MACHINE;
end architecture IMP;