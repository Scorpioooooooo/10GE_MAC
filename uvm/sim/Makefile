#############################
# User variables
#############################
TB       	= mac_tb
SEED     	= 1
GUI      ?= 0
COV      ?= 0
DOTCL    ?= 1
VERDI_GUI ?= 0
DVE_GUI   ?= 0
VERB     ?= UVM_HIGH
OUT      ?= out
TESTNAME ?= mac_small_packet_test
DFILES  	= ../../rtl/verilog/sync_clk_xgmii_tx.v \
						../../rtl/verilog/sync_clk_wb.v \
						../../rtl/verilog/sync_clk_core.v \
						../../rtl/verilog/generic_fifo_ctrl.v \
						../../rtl/verilog/generic_fifo.v \
						../../rtl/verilog/generic_mem_medium.v \
						../../rtl/verilog/generic_mem_small.v \
						../../rtl/verilog/meta_sync_single.v \
						../../rtl/verilog/meta_sync.v \
						../../rtl/verilog/wishbone_if.v \
						../../rtl/verilog/fault_sm.v \
						../../rtl/verilog/rx_dequeue.v \
						../../rtl/verilog/rx_enqueue.v \
						../../rtl/verilog/rx_data_fifo.v \
						../../rtl/verilog/rx_hold_fifo.v \
						../../rtl/verilog/tx_dequeue.v \
						../../rtl/verilog/tx_enqueue.v \
						../../rtl/verilog/tx_data_fifo.v \
						../../rtl/verilog/tx_hold_fifo.v \
						../../rtl/verilog/xge_mac.v \

VFILES   +=  ../agent/mac_pkg.sv \
						 ../env/xge_mac_pkg.sv \
						 ../tb/mac_if.sv \
						 ../tb/mac_tb.sv


#############################
# Environment variables
#############################
VCOMP_INC = +incdir+../../rtl/{include,verilog} \
						+incdir+../agent \
						+incdir+../{cfg,cov,reg,env,seq_lib,seq_lib/elem_seq,test} 
VCOMP    = vlogan -full64 -ntb_opts uvm-1.2 -sverilog  \
					 -timescale=1ps/1ps \
					 -nc -kdb \
					 -l $(OUT)/log/comp.log $(VCOMP_INC)
ELAB     = vcs -full64 -ntb_opts uvm-1.2  \
					 -debug_acc+all+reverse \
					 -l $(OUT)/log/elab.log -sim_res=1ps \
					 -lca -kdb
RUN      = $(OUT)/obj/$(TB).simv \
					 -l run.log  -sml \
					 +ntb_random_seed=$(SEED) \
					 +UVM_TESTNAME=$(TESTNAME) \
					 +UVM_VERBOSITY=$(VERB) \
					 -cm_dir $(CM_DIR) -cm_name $(CM_NAME) \
					 +UVM_VERDI_TRACE="UVM_AWARE+RAL+HIER+COMPWAVE" +UVM_TR_RECORD 
COV_OPTS = -full64 -dir $(CM_DIR)
CM_DIR  ?= $(OUT)/cov.vdb
CM_NAME ?= $(TESTNAME)_$(SEED)
SIMRUNFILE 	= mac_regre_tcl.do
ifeq ($(VERDI_GUI),1)
RUN += -gui=verdi
else ifeq ($(DVE_GUI),1)
RUN += -gui
endif
ifeq ($(DOTCL),1)
RUN += -ucli #-do $(SIMRUNFILE)
endif
ifeq ($(COV),1)
	ELAB  += -cm line+cond+fsm+tgl+branch+assert -cm_dir $(CM_DIR)
	RUN += -cm line+cond+fsm+tgl+branch+assert -covg_cont_on_error
endif

prepare:
	mkdir -p $(OUT)/work
	mkdir -p $(OUT)/log
	mkdir -p $(OUT)/sim
	mkdir -p $(OUT)/obj

comp: prepare
	$(VCOMP) 
	$(VCOMP) $(DFILES) $(VFILES)

elab: comp
	$(ELAB) -top $(TB) -o $(OUT)/obj/$(TB).simv  

run:
	$(RUN) 

mergecov:
	urg -format both $(COV_OPTS)

dvecov:
	dve $(COV_OPTS)

verdicov:
	verdi -cov -covdir $(CM_DIR)

htmlcov:
	firefox urgReport/dashboard.html

clean:
	rm -rf $(OUT) 64 AN.DB DVEfiles csrc *.simv *.simv.daidir *.simv.vdb ucli.key
	rm -rf *.log* *.vpd *.h urgReport inter* novas* work* *fsdb* verdiLog* regr* 

verdi:
	verdi $(DFILES) $(VFILES) -ssf mac_tb.fsdb &



