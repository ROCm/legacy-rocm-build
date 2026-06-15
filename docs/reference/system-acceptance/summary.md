---
orphan: true
---

# RDNA 3 and RDNA 4 system optimization pages — source summary

This document tracks where the content in each section of the RDNA 3 and RDNA 4
system optimization pages comes from, and flags sections that still need
validated data before publication.

---

## Acceptance-track pivot (Phase 1)

Direction change: the RDNA system optimization pages are being reshaped into a
single-card **acceptance/validation track**, parallel to (but separate from) the
strictly-Instinct customer acceptance guide at `C:\Work\system-acceptance-docs`.
The Instinct guide stays Instinct-only; RDNA gets its own track. The track is
being drafted in place in `docs/how-to/system-optimization` first; whether to
split it into its own docset is deferred until the shape is concrete.

### Phase 1 changes (done)

- **`index.rst`** reshaped into an acceptance overview: an "AMD RDNA system
  acceptance" section sequencing configuration/tuning then acceptance
  validation, plus a pointer to the Instinct acceptance guide. The RDNA3 and
  RDNA4 tuning pages (previously orphaned) are now linked here.
- **`rdna-health-checks.rst`** created. Single-card health checks with pass/fail
  criteria: OS check, GPU presence, PCIe link, driver-error scan, idle metrics,
  throttle status. Every command verified against
  `amdsmi/docs/how-to/amdsmi-cli-tool.md` (`--asic`, `--temperature`, `--power`,
  `--clock`, `--pcie` all confirmed). Unvalidated items carry visible notes.

### Phase 1 validated findings

- **PCIe device IDs — do NOT use a per-model table.** The `RvsBase.h`
  `gfx_to_rvs_conf` map (`rdc/include/rdc_modules/rdc_rvs/RvsBase.h`, lines
  40-56) lists **gfx target numbers, not PCIe device IDs** (it maps `0x942` to
  MI300X, while the Instinct docs use real PCIe ID `1002:74a1`). Real per-SKU
  IDs example from `rocm-bootstrap` README: gfx1100 → PCI `0x7448`,
  gfx1201 → PCI `0x7550`. These are single-machine examples, not a complete
  table. RDNA families span many SKUs, so the health-checks page detects by
  **vendor ID `1002` + `amd-smi static --asic`** instead of a device-ID table.
- **Throttle status on RDNA** confirmed from
  `amdsmi/docs/conceptual/gpu-violations.md`, lines 22-26: Radeon (Navi) GPUs
  use gpu_metrics v1.3 — read `throttle_status` / `indep_throttle_status` via
  `amd-smi metric --power`. The time-based violations API returns N/A on RDNA.
- **RVS validation support:** configs exist for RDNA3 (`nv31`:
  gst/iet/mem/pebb/peqt/pbqt/babel) under
  `rdc/rdc_libs/rdc_modules/rdc_rvs/conf/nv31/`. **No RDNA4 (`nv4x`) configs
  exist.** This is recorded as a "next steps" note on the health-checks page.
- **Perf-determinism matrix re-confirmed** (`amdsmi/docs/conceptual/
  perf-determinism.md`, lines 120-142): RDNA3 (Navi 3x) ✅ all perf-levels and
  determinism; RDNA4 (Navi 4x) ✅ AUTO only, the rest ❓ (depends on PMFW).

### Phase 1 open data dependencies (blocked on AMD/hardware)

- Pass/fail thresholds (GB/s, TFLOPS) for RDNA benchmarks — none in repos.
- Power-cap (`setpoweroverdrive`) and clock ranges — none found.
- Validated idle temperature/power/clock ranges per RDNA model.
- RDNA4 RVS configs and RDNA4 perf-level validation.

### Phase 2 changes (done)

- **`rdna-validation.rst`** created. RDNA3-only RVS validation page documenting
  the `nv31` configs, sourced from
  `rdc/rdc_libs/rdc_modules/rdc_rvs/conf/nv31/`. Modules covered: `rvs -g`
  detection, GPUP, GST, IET, MEM, PEQT, PEBB.
- **`index.rst`** updated to link the validation page under acceptance
  validation.

### Phase 2 verified findings (from the actual conf files)

- `gst_single.conf`: `sgemm`, 10 s duration, **`target_stress: 10000`** GFLOPS,
  matrix size 8640. Documented as the test's built-in target, NOT an
  AMD-published acceptance threshold.
- `iet_stress.conf`: `dgemm`, **`target_power: 127`** W, tolerance 0.06,
  `max_violations: 1`. Documented as the test's built-in value.
- `mem.conf`: standard memory pattern suite, `exclude: 9 10` (bit-fade and
  memory-stress subtests omitted by default).
- `peqt_single.conf`: 17 PCIe-qualification actions (link speed/width, atomics,
  `kernel_driver: ^amdgpu$`).
- `pebb_single.conf`: single bidirectional H2D/D2H bandwidth action, 51 MB block.
- `pbqt_single.conf` exists but is **P2P (multi-GPU)** — deliberately excluded
  from the single-card page.
- Other `nv31` files present but not documented (out of single-card scope or
  duplicate long-running variants): `gst_single_long`, `iet_stress_long`,
  `pebb_single_long`, `gst_stress_3_hrs`, `pesm_1`, `rcqt_single`.

### Phase 2 open data dependencies

- Per-card acceptance thresholds to replace the configs' built-in test targets.
- RDNA4 (`nv4x`) RVS configurations — do not exist.

### Phase 3 changes (done)

- **`rdna-benchmarks.rst`** created as a stub. Lists tools verified to run on
  RDNA (rocblas-bench, BabelStream, TransferBench) with all thresholds marked
  pending. Explicitly states the Instinct guide's commands/values are
  Instinct-specific and not transferable to RDNA.
- **`index.rst`** updated to link the benchmarks page.

### Phase 3 status

Stub only. No RDNA pass/fail thresholds exist in the repos, so the page presents
tools and pointers, not acceptance criteria. Blocked on AMD-published RDNA3 and
RDNA4 baselines — the single remaining dependency for a complete acceptance
track.

---

## RDNA 3 (`rdna3.rst`)

### System BIOS settings
- **Source:** Modeled on `rdna4.rst`, which follows standard PCIe compute
  recommendations (Above 4G decoding, Resizable BAR).
- **Status:** Not validated on a confirmed RDNA 3 system. Values are consistent
  with general AMD discrete GPU compute guidance.

### GRUB settings
- **Source:** Modeled on `rdna4.rst`. The `iommu=pt` recommendation is
  consistent with MI300X guidance.
- **Status:** Not validated on RDNA 3. Benefit on consumer desktop platforms
  has not been confirmed.

### Operating system settings
- **Source:** Links to the ROCm system requirements page.
- **Status:** No RDNA 3-specific kernel requirements are known beyond the
  standard ROCm support matrix.

### ROCm SMI tuning — Performance level, Power cap, Clock frequencies
- **Source:** Standard `rocm-smi` command reference.
- **Status:** Commands apply generically to AMD GPUs. No RDNA 3-specific
  values (clock ranges, power cap limits) have been validated and collected.

### ROCm SMI tuning — Performance determinism
- **Source:** `C:\Work\rocm-systems\projects\amdsmi\docs\conceptual\perf-determinism.md`
- **Specific content used:**
  - Support matrix confirming RDNA 3 (Navi 3x) has full support for all
    performance levels and performance determinism.
  - `amd-smi` commands: `set --perf-determinism`, `reset --perf-determinism`,
    `metric --perf-level`.
- **Status:** Confirmed. RDNA 3 is marked ✅ for all features in the support
  matrix.

### Counter collection
- **Source:** `C:\Work\rocm-systems\projects\rocprofiler-sdk\README.md`, line 107
- **Specific content used:**
  - Statement that gfx11 architectures require a stable power state for
    counter collection.
  - `amd-smi set -g <N> -l stable_std` and `amd-smi set -g <N> -l auto`
    commands.
  - `amd-smi static --asic -g <N>` command to identify the GPU target.
- **Status:** Confirmed.

### `amdgpu` module parameters
- **Source:** Live `systool -m amdgpu -v` output from an RDNA3 (gfx1100-series)
  system running amdgpu 6.16.13, provided by user.
- **Parameters documented:** `ppfeaturemask`, `sched_policy`, `cwsr_enable`,
  `no_system_mem_limit`, `num_kcq`, `queue_preemption_timeout_ms`.
- **Status:** Defaults confirmed on RDNA3. No specific tuning recommendations
  added beyond noting which parameters are relevant to compute workloads.
- **Fix also applied:** Corrected the `systool` grep pattern from
  `^\s+\w+ =` (matched only single-space-padded names) to `^\s+\w+\s+=`
  (matches all parameters regardless of padding width).

---

## RDNA 4 (`rdna4.rst`)

### System BIOS settings
- **Sources:**
  - CSM row: `https://www.amd.com/en/resources/support-articles/faqs/GPU-N4XCSM.html`
    (AMD official support article, published 2025-02-28). RDNA4 requires UEFI
    mode; CSM must be disabled.
  - Above 4G decoding and Resizable BAR: Standard PCIe compute recommendations.
- **Status:** CSM row confirmed by AMD official source. Above 4G decoding and
  Resizable BAR not yet validated on a confirmed RDNA4 platform. Noted in the
  file.

### GRUB settings
- **Source:** Consistent with MI300X guidance.
- **Status:** Not validated on RDNA 4 consumer desktop platforms. Noted in the
  file.

### Operating system settings
- **Source:** Links to the ROCm system requirements page.
- **Status:** No RDNA 4-specific kernel requirements are known beyond the
  standard ROCm support matrix.

### ROCm SMI tuning — Performance level, Power cap, Clock frequencies
- **Source:** Standard `rocm-smi` command reference.
- **Status:** Not validated on `gfx1200` or `gfx1201`. Noted in the file.
  Specific performance levels, power cap ranges, and clock values need
  confirmation.

### Counter collection
- **Source:** `C:\Work\rocm-systems\projects\rocprofiler-sdk\README.md`, line 107
- **Specific content used:**
  - Statement that gfx12 architectures require a stable power state for
    counter collection.
  - `amd-smi set -g <N> -l stable_std` and `amd-smi set -g <N> -l auto`
    commands.
  - `amd-smi static --asic -g <N>` command to identify the GPU target.
- **Status:** Confirmed.

### `amdgpu` module parameters
- **Source:** Live `systool -m amdgpu -v` output from an RDNA4 (gfx1200-series)
  system running amdgpu 6.12.12, provided by user.
- **Parameters documented:** `ppfeaturemask`, `sched_policy`, `cwsr_enable`,
  `no_system_mem_limit`, `num_kcq`, `queue_preemption_timeout_ms`.
- **Status:** Defaults confirmed on RDNA4. All six compute-relevant parameters
  have identical defaults to RDNA3. No specific tuning recommendations added
  beyond noting which parameters are relevant to compute workloads.
- **Fix also applied:** Corrected the `systool` grep pattern from
  `^\s+\w+ =` to `^\s+\w+\s+=`.

---

## Content found but not added — worth considering

### RDNA 4: Performance determinism (once confirmed)
- **Source:** `C:\Work\rocm-systems\projects\amdsmi\docs\conceptual\perf-determinism.md`
- **Why not added:** The support matrix marks RDNA 4 as ❓ (unconfirmed) for
  `--perf-level LOW`, `HIGH`, `MANUAL`, `STABLE_*`, and `--perf-determinism`.
  Only `--perf-level AUTO` is confirmed.
- **Action:** Once AMD SMI validates RDNA 4 support, add a Performance
  determinism subsection to `rdna4.rst` using the same structure as the RDNA 3
  page. The note in the file currently says this is unverified.

### RDNA 3: Known AQLProfile limitations on gfx1101 and gfx1102
- **Source:** `C:\Work\rocm-systems\projects\rocprofiler-sdk\tests\rocprofv3\counter-collection\input1\validate.py` and `kernel_filtering\validate.py`
- **Specific content:** Both validation scripts explicitly skip counter
  validation for `gfx1101` and `gfx1102` due to known AQLProfile bugs:
  ```python
  skip_gfx = ("gfx1101", "gfx1102", "gfx1150", "gfx1151", "gfx1152", "gfx1153")
  ```
- **Why not added:** This is a test-internal workaround, not a documented
  user-facing limitation. Needs confirmation from the ROCprofiler team on
  whether this affects end users and what the recommended workaround is before
  adding to the optimization page.
- **Action:** Check with the ROCprofiler SDK team. If this is a known
  user-facing issue, add a note to the Counter collection section of `rdna3.rst`
  describing the limitation and any workaround.

### RDNA 3: ATT (advanced thread tracing) HIP RT not supported on Navi3x
- **Source:** `C:\Work\rocm-systems\projects\rocprofiler\CHANGELOG.md`, line 228
- **Specific content:**
  > On Navi3x, counter collection requires the GPU to be in a stable power
  > state. See README.md for instructions. HIP RT in ATT not yet supported.
- **Why not added:** The stable power state requirement is already covered.
  The HIP RT limitation in ATT needs confirmation on whether it still applies
  to current ROCm releases or has since been resolved.
- **Action:** Verify current status with the ROCprofiler team. If still
  applicable, add a note to the Counter collection section of `rdna3.rst`.

### RDNA 3: Inconsistent power reporting on Navi31 and Navi32
- **Source:** `C:\Work\rocm-systems\projects\rocm-smi-lib\CHANGELOG.md`, line 690
- **Specific content:**
  > Fix: `rocm-smi --showpower` output was inconsistent on Navi32/31 devices.
  > Updated to use `rsmi_dev_power_get()` within CLI.
- **Why not added:** This is a changelog entry for a bug fix, not a tuning
  recommendation. The fix is already in the tool.
- **Action:** If the ROCm SMI tuning section is expanded with notes about
  command reliability, this could be referenced as context for why
  `rocm-smi --showpower` is the recommended approach over older APIs.

### RDNA 4: Triton backend recommended over Composable Kernel for wave32
- **Source:** Community guide (`gist.github.com/apollo-mg/ecba6a0c29323325a7ac3babf08e53be`),
  corroborated by `composablekernel/arch_specs.json` and `arch_filter.py`.
- **Specific content:** RDNA4 uses WAVE32 (32-thread waves) while most ROCm
  libraries default to CK backends optimized for CDNA WAVE64. Switching to
  OpenAI Triton as the backend generates kernels specifically for gfx1200/1201
  at runtime, avoiding the wave size mismatch. Relevant for PyTorch, vLLM, and
  flash-attention.
- **Why not added:** Framework/library-level choice, not a system configuration
  setting. The system optimization page is scoped to BIOS, kernel, driver, and
  `rocm-smi` tuning.
- **Action:** Consider a "Library and framework notes" section in `rdna4.rst`,
  or a separate RDNA4 compute guide. Needs AMD engineering confirmation before
  publication.

### RDNA 4: `FLASH_ATTENTION_TRITON_AMD_ENABLE=True` environment variable
- **Source:** Community guide (`gist.github.com/apollo-mg`).
- **Specific content:** Setting `FLASH_ATTENTION_TRITON_AMD_ENABLE="TRUE"` before
  installing flash-attn forces the Triton backend, bypassing the CK C++ backend
  that does not support RDNA4.
- **Why not added:** Application-level environment variable workaround, not a
  system optimization setting. May be resolved by upstream flash-attn in a future
  release.
- **Action:** Belongs in a framework-specific guide or an RDNA4 known issues page.

### RDNA 4: TunableOp for runtime GEMM tuning (PyTorch)
- **Source:** Community guide (`gist.github.com/apollo-mg`).
- **Specific content:** Enabling PyTorch TunableOp benchmarks available GEMM
  kernels at runtime and selects the fastest for gfx1200/1201.
- **Why not added:** PyTorch runtime setting, not a system-level configuration
  item.
- **Action:** Belongs in a PyTorch or AI framework optimization guide.

### RDNA 4: `VLLM_ROCM_USE_AITER=0` workaround for vLLM
- **Source:** Community guide (`gist.github.com/apollo-mg`), vllm-project/vllm
  issue #28649.
- **Specific content:** AITER's C++/ASM kernels do not work on RDNA4. Setting
  `VLLM_ROCM_USE_AITER=0` disables them. vLLM's FP8 path imports AITER Triton
  kernels that require architecture detection patching for gfx1201.
- **Why not added:** vLLM-specific workaround, not a system optimization setting.
  Likely to be resolved upstream.
- **Action:** Belongs in vLLM or RDNA4 inference tooling documentation.

---

## Additional findings from extended project search

The following projects were searched for RDNA2, RDNA3, RDNA3.5, and RDNA4 content
that could be added to the system optimization pages. Findings are listed below.

### `clr/hipamd` and `clr/rocclr`
- **Searched:** `C:\Work\rocm-systems\projects\clr\hipamd`, `C:\Work\rocm-systems\projects\clr\rocclr`
- **Findings:** Infrastructure code only — target ID mappings (gfx1030, gfx1100,
  gfx1200 etc.) and FP8 conditional compilation guards. No documentation content
  applicable to system optimization pages.
- **Action:** None.

### `hip`
- **Searched:** `C:\Work\rocm-systems\projects\hip`
- **Findings:** `docs/how-to/hardware_implementation.rst`,
  `hardware_features.rst`, `performance_optimization.rst` contain RDNA
  architecture descriptions. Content describes hardware features (compute units,
  wave size, shared memory) at a conceptual level; it is already more
  appropriately located in HIP documentation than in system optimization pages.
- **Action:** None for system optimization pages. No RDNA3/4-specific tuning
  settings identified.

### `rccl`
- **Searched:** `C:\Work\rocm-systems\projects\rccl`
- **Findings:** Build targets only (gfx1030, gfx1100, gfx1200). No
  documentation content with tuning guidance for RDNA targets.
- **Action:** None.

### `rocshmem`
- **Searched:** `C:\Work\rocm-systems\projects\rocshmem`
- **Findings:**
  1. CHANGELOG documents a gfx1201 memory coherency fix in ROCm 7.2.0. The
     recommended workaround is to use `HIPAllocatorFinegrained` instead of
     `HIPAllocatorUncached` when running rocSHMEM on gfx1201 with ROCm 7.2.0.
  2. This is a library-level workaround rather than a system optimization
     setting. It is captured below under "Content found but not added."
- **Action:** See "Content found but not added — rocSHMEM gfx1201 allocator
  workaround" below.

### `rocr-runtime`
- **Searched:** `C:\Work\rocm-systems\projects\rocr-runtime`
- **Findings:**
  1. **gfx1151 requires KFD ABI 1.20+.** The ROCr runtime checks the KFD
     interface version and will not initialize correctly on older kernels for
     gfx1151 (RDNA3.5 APU). This requirement aligns with the kernel version
     requirements already documented in `rdna3-5.rst`.
  2. **XNACK unsupported on all RDNA variants.** The runtime explicitly marks
     XNACK as unsupported for gfx1030/1031/1032, gfx1100-series, and
     gfx1200-series. Same for SRAM ECC.
  3. **RDNA2+ image resource descriptor change.** The PITCH field format differs
     between pre-RDNA2 and RDNA2+ hardware. Relevant to low-level compute
     developers writing custom image access; not a system-level tuning setting.
- **Action:** Items 1 and 2 are captured below under "Content found but not
  added." Item 3 is too low-level for system optimization pages.

### `rocprofiler-register`
- **Searched:** `C:\Work\rocm-systems\projects\rocprofiler-register`
- **Findings:** No RDNA-specific documentation or tuning content found. Project
  provides library registration infrastructure.
- **Action:** None.

### `rocprofiler-compute`
- **Searched:** `C:\Work\rocm-systems\projects\rocprofiler-compute`
- **Findings:** RDNA support described as "in progress" in the project
  documentation. Counter definition files exist for gfx1030, gfx1100, and
  gfx1200 series, but no user-facing tuning guidance is present. The tool is
  primarily targeted at Instinct GPUs.
- **Action:** None for system optimization pages.

### `rocdbgapi`
- **Searched:** `C:\Work\rocm-systems\projects\rocdbgapi`
- **Findings:**
  1. Known limitation: cooperative groups and CU masking are not supported for
     gfx1100, gfx1101, gfx1102 (RDNA3).
  2. Known limitation: cannot debug past an `s_sendmsg` instruction on
     gfx1100, gfx1101, gfx1102 targets.
  3. SR-IOV not supported on gfx1030, gfx1031, gfx1032 (RDNA2) for the debug
     API.
- **Action:** These are debugger limitations, not system optimization settings.
  Captured below under "Content found but not added."

### `instinct-virt-drv-docs`
- **Searched:** `C:\Work\instinct-virt-drv-docs`
- **Findings:** MxGPU (SR-IOV) virtualization documentation. Supported GPU list
  includes Instinct MI series and Radeon PRO V710 (RDNA3 architecture). No RDNA3
  or RDNA4 compute optimization content beyond what is already in the
  system-optimization pages. SR-IOV is explicitly out of scope for the RDNA
  system optimization pages per their introductions.
- **Action:** None.

---

## Content found but not added — worth considering

### RDNA 4: Performance determinism (once confirmed)
- **Source:** `C:\Work\rocm-systems\projects\amdsmi\docs\conceptual\perf-determinism.md`
- **Why not added:** The support matrix marks RDNA 4 as ❓ (unconfirmed) for
  `--perf-level LOW`, `HIGH`, `MANUAL`, `STABLE_*`, and `--perf-determinism`.
  Only `--perf-level AUTO` is confirmed.
- **Action:** Once AMD SMI validates RDNA 4 support, add a Performance
  determinism subsection to `rdna4.rst` using the same structure as the RDNA 3
  page. The note in the file currently says this is unverified.

### RDNA 3: Known AQLProfile limitations on gfx1101 and gfx1102
- **Source:** `C:\Work\rocm-systems\projects\rocprofiler-sdk\tests\rocprofv3\counter-collection\input1\validate.py` and `kernel_filtering\validate.py`
- **Specific content:** Both validation scripts explicitly skip counter
  validation for `gfx1101` and `gfx1102` due to known AQLProfile bugs:
  ```python
  skip_gfx = ("gfx1101", "gfx1102", "gfx1150", "gfx1151", "gfx1152", "gfx1153")
  ```
- **Why not added:** This is a test-internal workaround, not a documented
  user-facing limitation. Needs confirmation from the ROCprofiler team on
  whether this affects end users and what the recommended workaround is before
  adding to the optimization page.
- **Action:** Check with the ROCprofiler SDK team. If this is a known
  user-facing issue, add a note to the Counter collection section of `rdna3.rst`
  describing the limitation and any workaround.

### RDNA 3: ATT (advanced thread tracing) HIP RT not supported on Navi3x
- **Source:** `C:\Work\rocm-systems\projects\rocprofiler\CHANGELOG.md`, line 228
- **Specific content:**
  > On Navi3x, counter collection requires the GPU to be in a stable power
  > state. See README.md for instructions. HIP RT in ATT not yet supported.
- **Why not added:** The stable power state requirement is already covered.
  The HIP RT limitation in ATT needs confirmation on whether it still applies
  to current ROCm releases or has since been resolved.
- **Action:** Verify current status with the ROCprofiler team. If still
  applicable, add a note to the Counter collection section of `rdna3.rst`.

### RDNA 3: Inconsistent power reporting on Navi31 and Navi32
- **Source:** `C:\Work\rocm-systems\projects\rocm-smi-lib\CHANGELOG.md`, line 690
- **Specific content:**
  > Fix: `rocm-smi --showpower` output was inconsistent on Navi32/31 devices.
  > Updated to use `rsmi_dev_power_get()` within CLI.
- **Why not added:** This is a changelog entry for a bug fix, not a tuning
  recommendation. The fix is already in the tool.
- **Action:** If the ROCm SMI tuning section is expanded with notes about
  command reliability, this could be referenced as context for why
  `rocm-smi --showpower` is the recommended approach over older APIs.

### RDNA 4: rocSHMEM gfx1201 allocator workaround (ROCm 7.2.0)
- **Source:** `C:\Work\rocm-systems\projects\rocshmem\CHANGELOG.md`
- **Specific content:** With ROCm 7.2.0, `HIPAllocatorUncached` has a known
  memory coherency issue on gfx1201. The workaround is to use
  `HIPAllocatorFinegrained` instead.
- **Why not added:** This is a rocSHMEM library-level workaround, not a
  system-level tuning setting. It is library-version and ROCm-version specific
  and may be resolved in a later release.
- **Action:** If a rocSHMEM-specific section is added to `rdna4.rst`, include
  this note. Otherwise, it belongs in rocSHMEM's own documentation.

### RDNA 3.5: KFD ABI 1.20+ requirement for gfx1151
- **Source:** `C:\Work\rocm-systems\projects\rocr-runtime`
- **Specific content:** The ROCr runtime requires KFD ABI version 1.20 or later
  for gfx1151 (Ryzen AI Max series). Older kernels will not initialize the
  runtime correctly for this target.
- **Why not added:** The `rdna3-5.rst` page already documents specific minimum
  kernel versions for gfx1151. The KFD ABI version is an implementation detail
  rather than a user-actionable setting.
- **Action:** If a troubleshooting section is added to `rdna3-5.rst`, this
  could be referenced as the underlying reason for the kernel version requirement.

### ~~RDNA 2–4: XNACK and SRAM ECC unsupported~~ — Added
- **Source:** `C:\Work\rocm-systems\projects\rocr-runtime`
- **Added to:** `rdna3.rst` (`amdgpu` module parameters section),
  `rdna4.rst` (`amdgpu` module parameters section),
  `rdna3-5.rst` (operating system support section, after kernel version table).
- **Content added:** A "XNACK and SRAM ECC" subsection in each file noting
  that XNACK and SRAM ECC are unsupported on the respective targets and should
  not be enabled in `amdgpu` module configuration.

### RDNA 3: rocdbgapi known limitations on gfx1100, gfx1101, gfx1102
- **Source:** `C:\Work\rocm-systems\projects\rocdbgapi`
- **Specific content:**
  - Cooperative groups and CU masking are not supported for gfx1100, gfx1101,
    gfx1102.
  - Cannot debug past an `s_sendmsg` instruction on these targets.
- **Why not added:** These are debugger limitations, not system optimization
  settings. They belong in ROCm debugger documentation rather than the system
  optimization page.
- **Action:** No action for system optimization pages. Flag to the rocdbgapi
  documentation team.

---

## Sources searched but not used

| Project | Reason not used |
|---|---|
| `rocm-smi-lib` | Only changelog bug fix entries for Navi3x; no doc-level tuning content |
| `rocprofiler` (v1) | gfx11 references only in build targets and metrics XML; no documentation content |
| `rocprofiler-sdk` docs (`using-rocprofv3.rst`, `counter_collection_services.rst`) | gfx11/gfx12 references only in architecture lists within code examples; no additional tuning guidance beyond what the README provided |
| RDNA 4 ISA PDF (`rdna4-instruction-set-architecture.pdf`) | Does not contain throughput or latency tables for SWMMAC; used only for SWMMAC instruction reference |
| `clr/hipamd`, `clr/rocclr` | Infrastructure code only; no documentation content |
| `hip` | RDNA architecture descriptions in HIP docs; not system optimization content |
| `rccl` | Build targets only |
| `rocshmem` | gfx1201 library workaround only; not a system-level setting |
| `rocr-runtime` | KFD ABI and XNACK findings; too low-level or already covered |
| `rocprofiler-register` | No RDNA-specific content |
| `rocprofiler-compute` | RDNA support in progress; no user-facing tuning guidance |
| `rocdbgapi` | Debugger limitations; not system optimization settings |
| `instinct-virt-drv-docs` | SR-IOV virtualization docs; out of scope for compute optimization pages |
| `composablekernel` | Wave size and scheduler constraints are library/kernel developer knowledge, not system tuning settings |
| `hipblas` | Changelog entry confirming RDNA4 target support; version info already covered by ROCm system requirements |
| `hipblas-common` | No RDNA-specific content |
| `hipblaslt` | Build system internals only |
| `hipcub` | Changelog deprecation notices; no system-level tuning content |
| `hipdnn` | No RDNA-specific content |
| `hipfft` | Changelog entries for target support additions; no tuning guidance |
| `hiprand` | Changelog entries for target support additions; no tuning guidance |
| `hipsolver` | No RDNA-specific content |
| `hipsparse` | No RDNA-specific content |
| `hipsparselt` | No RDNA-specific content |
| `hiptensor` | FP64/F8 datatype constraints are library API limitations, not system configuration |
| `miopen` | Navi LDS bug already fixed; CK RDNA support addition is library news, not tuning guidance |
| `rocblas` | Changelog target support additions only |
| `rocfft` | Per-architecture kernel cache is an implementation detail; gfx1201 FFT performance note is library-internal |
| `rocprim` | Deterministic scan limitation on Navi3x is a library API known issue, not a system tuning setting |
| `rocrand` | Build target additions only |
| `rocsolver` | No RDNA-specific content found |
| `rocsparse` | Target support additions only |
| `rocthrust` | Build target additions only |
| `rocwmma` | F8/BF8 RDNA4-only constraint is a library API capability, not a system configuration item |
