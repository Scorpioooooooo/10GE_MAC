#======================================#
# TCL script for a mini regression     #
#======================================#

# makesure all tests run is finished
onbreak resume
onerror resume

# set environment varables
setenv DUT_SRC ../../rtl/{include,verdlog}
setenv TB_SRC ../{agent,cfg,cov,reg,env,seq_lib,seq_lib/elem_seq,test}

# clean the environment and remove trash files
set delfiles [glob *.log *.vdb *.simv *.log* *.vpd *.h urgReport inter* novas* work* *fsdb* *.simv.daidir *.simv.vdb ucli.key 64 AN.DB DVEfiles csrc]
file delete -froce {*}$delfiles

# prepare folder
file mkdir -p out/work
file mkdir -p out/log
file mkdir -p out/sim
file mkdir -p out/obj

# compile the design and dut with filelist
set TB "mac_tb"
set VCOMP_CMD "vlogan -full64 -ntb_opts uvm_1.2 -sverilog -timescale=1ps/1ps -nc -ktb  +incdir+$env(DUT_SRC) +incdir+$env(TB_SRC) -f mac.flist"
set ELAB_CMD "vcs -top $TB -o out/obj/mac_tb.simv -cm line+cond+fsm+tgl+branch+assert -cm_dir $CM_DIR"

# outPath
set VCOMP_OUT "./out/log/comp.log"
set ELAB_OUT "./out/log/elab.log"
set SIM_PATH "out/obj/mac_tb.simv"

# prepare simrun folder
set timetag [clock format [clock seconds] -format "%Y%b%d-%H_%M"]
file mkdir regr_vdb_${timetag}

# UVM
set VERB UVM_HIGH

# Loop over each test case
set TestCase { {mac_small_packet_test 5} \
                {mac_large_packet_test 5} \
                {mac_oversized_packet_test 1} \
                {mac_ipg_packet_test 10} \ 
              
              }

foreach testcase $TestCase {
    set testname [lindex $testcase 0]
    set LoopNum  [lindex $testcase 1]
    for {set loop 0} {$loop < LoopNum} {incr loop} {
       set seed [expr int(rand() * 100)]
       set CM_DIR "regr_vdb_${timetag}"
       echo simulating $testname
       echo $seed +UVM_TESTNAME=$testname -l regr_vdb_${timetag}/run_${testname}_${seed}.log
#Step 1: Compile
       if {[catch {exec $VCOMP_CMD > $VCOMP_OUT 2>&1} result]} {
            puts "Error: Compilation failed for $testcase"
            puts $result
            continue
            }
#Step 2: Elaborate
       if {[catch {exec $ELAB_CMD > $ELAB_OUT 2>&1} result]} {
            puts "Error: Elaboration failed for $testcase"
            puts $result
            continue
            }         
#Step 3: Run 
        exec $SIM_PATH 
        +UVM_TESTNAME=$testname -ntb_random_seed=$seed \
        -l regr_vdb_${timetag}/run_${testname}_${seed}.log \
        -cm_dir $CM_DIR -cm_name ${testname}_${seed} \
        +UVM_VERBOSITY=$VERB \
        -onfinish stop \
        -cm line+cond+fsm+tgl+branch+assert -covg_cont_on_error
#Step 4: Save coverage_file    
       urg -dir $CM_DIR -report ${testname}_${seed}.vdb
         
       }
  }
