`ifndef MH_AXI_AGENT_PKG_sV
    `define MH_AXI_AGENT_PKG_sV

    `include "uvm_macros.svh"


    package mh_axi_agent_pkg;
        import uvm_pkg::*;
        // types file
        `include "mh_axi_types.sv"

        // sequence_items
        `include "mh_axi_item_base.sv"
        `include "mh_axi_item_base_aw.sv"
        `include "mh_axi_item_base_w.sv"
        `include "mh_axi_item_drv_w.sv"
        `include "mh_axi_item_mon_w.sv"
        `include "mh_axi_item_base_b.sv"
        `include "mh_axi_item_drv_b.sv"
        `include "mh_axi_item_mon_b.sv"

       
        // agent_config components
        `include "mh_axi_agent_config.sv"
        `include "mh_axi_agent_config_aw.sv"
        `include "mh_axi_agent_config_w.sv"
        `include "mh_axi_agent_config_b.sv"
        // sequencers
        `include "mh_axi_sequencer_base.sv"
        `include "mh_axi_sequencer_aw.sv"
        `include "mh_axi_sequencer_w.sv"
        `include "mh_axi_sequencer_b.sv"
        // drivers
        `include "mh_axi_driver.sv"
        `include "mh_axi_driver_aw.sv"
        `include "mh_axi_driver_w.sv"
        `include "mh_axi_driver_b.sv"
        // monitors
        `include "mh_axi_monitor.sv"
        `include "mh_axi_monitor_aw.sv"
        `include "mh_axi_monitor_w.sv"
        `include "mh_axi_monitor_b.sv"
        // coverage components
        `include "mh_axi_coverage.sv"
        `include "mh_axi_coverage_aw.sv"
        `include "mh_axi_coverage_w.sv"

        // generic agent
        `include "mh_axi_agent.sv"
        // 1. agent for the aw channel
        `include "mh_axi_agent_aw.sv"
        // 2. agent for the w channel
        `include "mh_axi_agent_w.sv"
        // 3. agent for the b channel
        `include "mh_axi_agent_b.sv"
        // 4. agent for the ar channel
        // 5. agent for the r channel

        // sequences
        `include "mh_axi_sequence_base_aw.sv"
        `include "mh_axi_sequence_base_w.sv"
        `include "mh_axi_sequence_base_b.sv"

    endpackage

`endif