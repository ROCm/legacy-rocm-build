.. meta::
  :description: MI355 Series performance counters and metrics
  :keywords: MI355, MI355X, MI3XX

***********************************
MI350 Series performance counters
***********************************

This topic lists and describes the hardware performance counters and derived metrics available on the AMD Instinct MI350 and MI355 GPUs. These counters are available for profiling using `ROCprofiler-SDK <https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/index.html>`_ and `ROCm Compute Profiler <https://rocm.docs.amd.com/projects/rocprofiler-compute/en/latest/>`_.

The following sections list the performance counters based on the IP blocks.

Command processor packet processor counters (CPC)
==================================================

.. list-table::
    :header-rows: 1

    * - Hardware counter
      - Definition

    * - CPC_ALWAYS_COUNT
      - Always count.

    * - CPC_ADC_VALID_CHUNK_NOT_AVAIL
      - ADC valid chunk is not available when dispatch walking is in progress in the multi-xcc mode.

    * - CPC_ADC_DISPATCH_ALLOC_DONE
      - ADC dispatch allocation is done.

    * - CPC_ADC_VALID_CHUNK_END
      - ADC crawler's valid chunk end in the multi-xcc mode.

    * - CPC_SYNC_FIFO_FULL_LEVEL
      - SYNC FIFO full last cycles.

    * - CPC_SYNC_FIFO_FULL
      - SYNC FIFO full times.

    * - CPC_GD_BUSY
      - ADC busy.

    * - CPC_TG_SEND
      - ADC thread group send.

    * - CPC_WALK_NEXT_CHUNK
      - ADC walking next valid chunk in the multi-xcc mode.

    * - CPC_STALLED_BY_SE0_SPI
      - ADC CSDATA stalled by SE0SPI.

    * - CPC_STALLED_BY_SE1_SPI
      - ADC CSDATA stalled by SE1SPI.

    * - CPC_STALLED_BY_SE2_SPI
      - ADC CSDATA stalled by SE2SPI.

    * - CPC_STALLED_BY_SE3_SPI
      - ADC CSDATA stalled by SE3SPI.

    * - CPC_LTE_ALL
      - CPC sync counter LteAll. Only Master XCD manages LteAll.

    * - CPC_SYNC_WRREQ_FIFO_BUSY
      - CPC sync counter request FIFO is not empty.

    * - CPC_CANE_BUSY
      - CPC CANE bus is busy, which indicates the presence of inflight sync counter requests.

    * - CPC_CANE_STALL
      - CPC sync counter sending is stalled by CANE.

Shader pipe interpolators (SPI) counters
=========================================

.. list-table::
    :header-rows: 1

    * - Hardware counter
      - Definition

    * - SPI_CS0_WINDOW_VALID
      - Clock count enabled by PIPE0 perfcounter_start event.

    * - SPI_CS0_BUSY
      - Number of clocks with outstanding waves for PIPE0 (SPI or SH).

    * - SPI_CS0_NUM_THREADGROUPS
      - Number of thread groups launched for PIPE0.

    * - SPI_CS0_CRAWLER_STALL
      - Number of clocks when PIPE0 event or wave order FIFO is full.

    * - SPI_CS0_EVENT_WAVE
      - Number of PIPE0 events and waves.

    * - SPI_CS0_WAVE
      - Number of PIPE0 waves.

    * - SPI_CS1_WINDOW_VALID
      - Clock count enabled by PIPE1 perfcounter_start event.

    * - SPI_CS1_BUSY
      - Number of clocks with outstanding waves for PIPE1 (SPI or SH).

    * - SPI_CS1_NUM_THREADGROUPS
      - Number of thread groups launched for PIPE1.

    * - SPI_CS1_CRAWLER_STALL
      - Number of clocks when PIPE1 event or wave order FIFO is full.

    * - SPI_CS1_EVENT_WAVE
      - Number of PIPE1 events and waves.

    * - SPI_CS1_WAVE
      - Number of PIPE1 waves.

    * - SPI_CS2_WINDOW_VALID
      - Clock count enabled by PIPE2 perfcounter_start event.

    * - SPI_CS2_BUSY
      - Number of clocks with outstanding waves for PIPE2 (SPI or SH).

    * - SPI_CS2_NUM_THREADGROUPS
      - Number of thread groups launched for PIPE2.

    * - SPI_CS2_CRAWLER_STALL
      - Number of clocks when PIPE2 event or wave order FIFO is full.

    * - SPI_CS2_EVENT_WAVE
      - Number of PIPE2 events and waves.

    * - SPI_CS2_WAVE
      - Number of PIPE2 waves.

    * - SPI_CS3_WINDOW_VALID
      - Clock count enabled by PIPE3 perfcounter_start event.

    * - SPI_CS3_BUSY
      - Number of clocks with outstanding waves for PIPE3 (SPI or SH).

    * - SPI_CS3_NUM_THREADGROUPS
      - Number of thread groups launched for PIPE3.

    * - SPI_CS3_CRAWLER_STALL
      - Number of clocks when PIPE3 event or wave order FIFO is full.

    * - SPI_CS3_EVENT_WAVE
      - Number of PIPE3 events and waves.

    * - SPI_CS3_WAVE
      - Number of PIPE3 waves.

    * - SPI_CSQ_P0_Q0_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue0.

    * - SPI_CSQ_P0_Q1_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue1.

    * - SPI_CSQ_P0_Q2_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue2.

    * - SPI_CSQ_P0_Q3_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue3.

    * - SPI_CSQ_P0_Q4_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue4.

    * - SPI_CSQ_P0_Q5_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue5.

    * - SPI_CSQ_P0_Q6_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue6.

    * - SPI_CSQ_P0_Q7_OCCUPANCY
      - Sum of occupancy info for PIPE0 Queue7.

    * - SPI_CSQ_P1_Q0_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue0.

    * - SPI_CSQ_P1_Q1_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue1.

    * - SPI_CSQ_P1_Q2_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue2.

    * - SPI_CSQ_P1_Q3_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue3.

    * - SPI_CSQ_P1_Q4_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue4.

    * - SPI_CSQ_P1_Q5_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue5.

    * - SPI_CSQ_P1_Q6_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue6.

    * - SPI_CSQ_P1_Q7_OCCUPANCY
      - Sum of occupancy info for PIPE1 Queue7.

    * - SPI_CSQ_P2_Q0_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue0.

    * - SPI_CSQ_P2_Q1_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue1.

    * - SPI_CSQ_P2_Q2_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue2.

    * - SPI_CSQ_P2_Q3_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue3.

    * - SPI_CSQ_P2_Q4_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue4.

    * - SPI_CSQ_P2_Q5_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue5.

    * - SPI_CSQ_P2_Q6_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue6.

    * - SPI_CSQ_P2_Q7_OCCUPANCY
      - Sum of occupancy info for PIPE2 Queue7.

    * - SPI_CSQ_P3_Q0_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue0.

    * - SPI_CSQ_P3_Q1_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue1.

    * - SPI_CSQ_P3_Q2_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue2.

    * - SPI_CSQ_P3_Q3_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue3.

    * - SPI_CSQ_P3_Q4_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue4.

    * - SPI_CSQ_P3_Q5_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue5.

    * - SPI_CSQ_P3_Q6_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue6.

    * - SPI_CSQ_P3_Q7_OCCUPANCY
      - Sum of occupancy info for PIPE3 Queue7.

    * - SPI_CSQ_P0_OCCUPANCY
      - Sum of occupancy info for all PIPE0 queues.

    * - SPI_CSQ_P1_OCCUPANCY
      - Sum of occupancy info for all PIPE1 queues.

    * - SPI_CSQ_P2_OCCUPANCY
      - Sum of occupancy info for all PIPE2 queues.

    * - SPI_CSQ_P3_OCCUPANCY
      - Sum of occupancy info for all PIPE3 queues.

    * - SPI_VWC0_VDATA_VALID_WR
      - Number of clocks VGPR bus_0 writes VGPRs.

    * - SPI_VWC1_VDATA_VALID_WR
      - Number of clocks VGPR bus_1 writes VGPRs.

    * - SPI_CSC_WAVE_CNT_BUSY
      - Number of cycles when there is any wave in the pipe.

Compute unit (SQ) counters
===========================

.. list-table::
    :header-rows: 1

    * - Hardware counter
      - Definition

    * - SQ_INSTS_VALU_MFMA_F6F4
      - Number of VALU V_MFMA_*_F6F4 instructions.

    * - SQ_INSTS_VALU_MFMA_MOPS_F6F4
      - Number of VALU matrix with the performed math operations (add or mul) divided by 512, assuming a full EXEC mask of F6 or F4 data type.

    * - SQ_ACTIVE_INST_VALU2
      - Number of quad-cycles when two VALU instructions are issued (per-simd, nondeterministic).

    * - SQ_INSTS_LDS_LOAD
      - Number of LDS load instructions issued (per-simd, emulated).

    * - SQ_INSTS_LDS_STORE
      - Number of LDS store instructions issued (per-simd, emulated).

    * - SQ_INSTS_LDS_ATOMIC
      - Number of LDS atomic instructions issued (per-simd, emulated).

    * - SQ_INSTS_LDS_LOAD_BANDWIDTH
      - Total number of 64-bytes loaded (instrSize * CountOnes(EXEC))/64 (per-simd, emulated).

    * - SQ_INSTS_LDS_STORE_BANDWIDTH
      - Total number of 64-bytes written (instrSize * CountOnes(EXEC))/64 (per-simd, emulated).

    * - SQ_INSTS_LDS_ATOMIC_BANDWIDTH
      - Total number of 64-bytes atomic (instrSize * CountOnes(EXEC))/64 (per-simd, emulated).

    * - SQ_INSTS_VALU_FLOPS_FP16
      - Counts FLOPS per instruction on float 16 excluding MFMA/SMFMA.

    * - SQ_INSTS_VALU_FLOPS_FP32
      - Counts FLOPS per instruction on float 32 excluding MFMA/SMFMA.

    * - SQ_INSTS_VALU_FLOPS_FP64
      - Counts FLOPS per instruction on float 64 excluding MFMA/SMFMA.

    * - SQ_INSTS_VALU_FLOPS_FP16_TRANS
      - Counts FLOPS per instruction on float 16 trans excluding MFMA/SMFMA.

    * - SQ_INSTS_VALU_FLOPS_FP32_TRANS
      - Counts FLOPS per instruction on float 32 trans excluding MFMA/SMFMA.

    * - SQ_INSTS_VALU_FLOPS_FP64_TRANS
      - Counts FLOPS per instruction on float 64 trans excluding MFMA/SMFMA.

    * - SQ_INSTS_VALU_IOPS
      - Counts OPS per instruction on integer or unsigned or bit data (per-simd, emulated).

    * - SQ_LDS_DATA_FIFO_FULL
      - Number of cycles LDS data FIFO is full (nondeterministic, unwindowed).

    * - SQ_LDS_CMD_FIFO_FULL
      - Number of cycles LDS command FIFO is full (nondeterministic, unwindowed).

    * - SQ_VMEM_TA_ADDR_FIFO_FULL
      - Number of cycles texture requests are stalled due to full address FIFO in TA (nondeterministic, unwindowed).

    * - SQ_VMEM_TA_CMD_FIFO_FULL
      - Number of cycles texture requests are stalled due to full cmd FIFO in TA (nondeterministic, unwindowed).

    * - SQ_VMEM_WR_TA_DATA_FIFO_FULL
      - Number of cycles texture writes are stalled due to full data FIFO in TA (nondeterministic, unwindowed).

    * - SQC_ICACHE_MISSES_DUPLICATE
      - Number of duplicate misses (access to a non-resident, miss pending CL) (per-SQ, per-Bank, nondeterministic).

    * - SQC_DCACHE_MISSES_DUPLICATE
      - Number of duplicate misses (access to a non-resident, miss pending CL) (per-SQ, per-Bank, nondeterministic).

Texture addressing (TA) unit counters
======================================

.. list-table::
    :header-rows: 1

    * - Hardware counter
      - Definition

    * - TA_BUFFER_READ_LDS_WAVEFRONTS
      - Number of buffer read wavefronts for LDS return processed by the TA.

    * - TA_FLAT_READ_LDS_WAVEFRONTS
      - Number of flat opcode reads for LDS return processed by the TA.

Texture data (TD) unit counters
================================

.. list-table::
    :header-rows: 1

    * - Hardware counter
      - Definition

    * - TD_WRITE_ACKT_WAVEFRONT
      - Number of write acknowledgments, sent to SQ and not to SP.

    * - TD_TD_SP_TRAFFIC
      - Number of times this TD sends data to the SP.

Texture cache per pipe (TCP) counters
======================================

.. list-table::
    :header-rows: 1

    * - Hardware counter
      - Definition

    * - TCP_TCP_TA_ADDR_STALL_CYCLES
      - TCP stalls TA addr interface.

    * - TCP_TCP_TA_DATA_STALL_CYCLES
      - TCP stalls TA data interface. Now windowed.

    * - TCP_LFIFO_STALL_CYCLES
      - Memory latency FIFOs full stall.

    * - TCP_RFIFO_STALL_CYCLES
      - Memory Request FIFOs full stall.

    * - TCP_TCR_RDRET_STALL
      - Write into cache stalled by read return from TCR.

    * - TCP_PENDING_STALL_CYCLES
      - Stall due to data pending from L2.

    * - TCP_UTCL1_SERIALIZATION_STALL
      - Total number of stalls caused due to serializing translation requests through the UTCL1.

    * - TCP_UTCL1_THRASHING_STALL
      - Stall caused by thrashing feature in any probe. Lacks accuracy when the stall signal overlaps between probe0 and probe1, which is worse with MECO of thrashing deadlock. Some probe0 events could miss being counted in with MECO on. This perf count provides a rough thrashing estimate.

    * - TCP_UTCL1_TRANSLATION_MISS_UNDER_MISS
      - Translation miss_under_miss.

    * - TCP_UTCL1_STALL_INFLIGHT_MAX
      - Total UTCL1 stalls due to inflight counter saturation.

    * - TCP_UTCL1_STALL_LRU_INFLIGHT
      - Total UTCL1 stalls due to LRU cache line with inflight traffic.

    * - TCP_UTCL1_STALL_MULTI_MISS
      - Total UTCL1 stalls due to arbitrated multiple misses.

    * - TCP_UTCL1_LFIFO_FULL
      - Total UTCL1 and UTCL2 latency, which hides FIFO full cycles.

    * - TCP_UTCL1_STALL_LFIFO_NOT_RES
      - Total UTCL1 stalls due to UTCL2 latency, which hides FIFO output (not resident).

    * - TCP_UTCL1_STALL_UTCL2_REQ_OUT_OF_CREDITS
      - Total UTCL1 stalls due to UTCL2_req being out of credits.

    * - TCP_CLIENT_UTCL1_INFLIGHT
      - The sum of inflight client to UTCL1 requests per cycle.

    * - TCP_TAGRAM0_REQ
      - Total L2 requests mapping to TagRAM 0 from this TCP to all TCCs.

    * - TCP_TAGRAM1_REQ
      - Total L2 requests mapping to TagRAM 1 from this TCP to all TCCs.

    * - TCP_TAGRAM2_REQ
      - Total L2 requests mapping to TagRAM 2 from this TCP to all TCCs.

    * - TCP_TAGRAM3_REQ
      - Total L2 requests mapping to TagRAM 3 from this TCP to all TCCs.

    * - TCP_TCP_LATENCY
      - Total TCP wave latency (from the first clock of wave entering to the first clock of wave leaving). Divide by TA_TCP_STATE_READ to find average wave latency.

    * - TCP_TCC_READ_REQ_LATENCY
      - Total TCP to TCC request latency for reads and atomics with return. Not Windowed.

    * - TCP_TCC_WRITE_REQ_LATENCY
      - Total TCP to TCC request latency for writes and atomics without return. Not Windowed.

    * - TCP_TCC_WRITE_REQ_HOLE_LATENCY
      - Total TCP req to TCC hole latency for writes and atomics. Not Windowed.

Texture cache per channel (TCC) counters
=========================================

.. list-table::
    :header-rows: 1

    * - Hardware counter
      - Definition

    * - TCC_READ_SECTORS
      - Total number of 32B data sectors in read requests.

    * - TCC_WRITE_SECTORS
      - Total number of 32B data sectors in write requests.

    * - TCC_ATOMIC_SECTORS
      - Total number of 32B data sectors in atomic requests.

    * - TCC_BYPASS_REQ
      - Number of bypass requests. This is measured at the tag block.

    * - TCC_LATENCY_FIFO_FULL
      - Number of cycles when the latency FIFO is full.

    * - TCC_SRC_FIFO_FULL
      - Number of cycles when the SRC FIFO is assumed to be full as measured at the IB block.

    * - TCC_EA0_RDREQ_64B
      - Number of 64-byte TCC/EA read requests.

    * - TCC_EA0_RDREQ_128B
      - Number of 128-byte TCC/EA read requests.

    * - TCC_IB_REQ
      - Number of requests through the IB. This measures the number of raw requests from graphics clients to this TCC.

    * - TCC_IB_STALL
      - Number of cycles when the IB output is stalled.

    * - TCC_EA0_WRREQ_WRITE_DRAM
      - Number of TCC/EA write requests (32-byte or 64-byte) destined for DRAM (MC).

    * - TCC_EA0_WRREQ_ATOMIC_DRAM
      - Number of TCC/EA atomic requests (32-byte or 64-byte) destined for DRAM (MC).

    * - TCC_EA0_RDREQ_DRAM_32B
      - Number of 32-byte TCC/EA read requests due to DRAM traffic. One 64-byte request is counted as two and one 128-byte as four.

    * - TCC_EA0_RDREQ_GMI_32B
      - Number of 32-byte TCC/EA read requests due to GMI traffic. One 64-byte request is counted as two and one 128-byte as four.

    * - TCC_EA0_RDREQ_IO_32B
      - Number of 32-byte TCC/EA read requests due to IO traffic. One 64-byte request is counted as two and one 128-byte as four.

    * - TCC_EA0_WRREQ_WRITE_DRAM_32B
      - Number of 32-byte TCC/EA write requests due to DRAM traffic. One 64-byte request is counted as two.

    * - TCC_EA0_WRREQ_ATOMIC_DRAM_32B
      - Number of 32-byte TCC/EA atomic requests due to DRAM traffic. One 64-byte request is counted as two.

    * - TCC_EA0_WRREQ_WRITE_GMI_32B
      - Number of 32-byte TCC/EA write requests due to GMI traffic. One 64-byte request is counted as two.

    * - TCC_EA0_WRREQ_ATOMIC_GMI_32B
      - Number of 32-byte TCC/EA atomic requests due to GMI traffic. One 64-byte request is counted as two.

    * - TCC_EA0_WRREQ_WRITE_IO_32B
      - Number of 32-byte TCC/EA write requests due to IO traffic. One 64-byte request is counted as two.

    * - TCC_EA0_WRREQ_ATOMIC_IO_32B
      - Number of 32-byte TCC/EA atomic requests due to IO traffic. One 64-byte request is counted as two.
