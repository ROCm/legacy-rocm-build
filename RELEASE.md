# ROCm Core SDK 7.9.0 release notes

ROCm Core SDK 7.9.0 introduces a technology preview release aimed at helping
developers explore the new ROCm build and release infrastructure system called
[TheRock](https://github.com/rocm/therock). See [ROCm Core SDK and TheRock
Build
System](https://rocm.blogs.amd.com/software-tools-optimization/therock/README.html)
for more information. This release focuses on foundational improvements and
streamlining the development experience.

(preview-stream-note)=
```{important}
ROCm 7.9.0 introduces a versioning discontinuity following
the previous 7.0 releases. Versions 7.0 through 7.8 are reserved for
production stream ROCm releases, while versions 7.9 and later represent the
technology preview release stream. Both streams share a largely similar code
base but differ in their build systems. These differences include the CMake
configuration, operating system package dependencies, and integration of AMD
GPU driver components.

Maintaining parallel release streams allows users ample time to evaluate and
adopt the new build system and dependency changes. The technology preview
stream is planned to continue through mid‑2026, after which it will replace the
[current production stream](https://rocm.docs.amd.com/en/latest/).
```

### Release highlights

This technology preview of the ROCm Core SDK with TheRock introduces several
key foundational changes:

* **ManyLinux_2_28 compliance**: Enables single builds to support multiple Linux distributions, improving portability and simplifying deployment.
* **Architecture-specific Python packages**: Redesigned to target individual GPU architectures, reducing disk usage and improving modularity.
* **Slimmed-down SDK**: Focuses on core GPU compute capabilities with a minimal set of runtime components, libraries, and tools.

In addition to these technical updates, this release also begins the transition
to a more open and predictable development process:

* **Open release process**: Transition to a fully open model with public release candidates, nightly builds, and transparent pull request workflows.
* **Predictable release cadence**: Major and minor versions will follow a fixed 6-week release cycle.

### 7.9.0 compatibility notice

In terms of package compatibility, ROCm 7.9.0 diverges from the existing ROCm
7.0 stream and upcoming stable releases in that stream:

* **No upgrade path** from existing production releases -- including ROCm 7.0 and earlier -- as well as from upcoming stable releases. See the [explanatory note](#preview-stream-note).
* **Not intended for production workloads** -- users running production environments should continue using the [ROCm 7.0 stream](https://rocm.docs.amd.com/en/latest/).
  See the [explanatory note](#preview-stream-note).
* **Not fully featured** -- this release is a stepping stone toward fully open software development.

### 7.9.0 support

* **Hardware support**: Builds are limited to AMD Instinct MI350 Series GPUs, MI300 Series GPUs and APUs, Ryzen AI Max PRO 300 Series APUs, and Ryzen AI Max 300 Series APUs. See [Supported hardware and operating systems](#supported-hardware-and-operating-systems).
* **Packaging format**: RPM and Debian packages are not available in this initial release. Instead, Python wheels and tarballs are provided. See the [ROCm 7.9.0 installation instructions](/install/rocm).
* **Software components**: Some components of the ROCm Core SDK are not yet
  available in this release. Additional components are planned to be introduced in
  future preview releases as part of the ROCm Core SDK. Components not included in
  the future Core SDK will either:
  * Be released as standalone project-specific packages, or
  * Be grouped into ROCm Expansion SDKs.

### Looking ahead

Subsequent technology preview releases will follow a 6-week cadence, gradually
filling gaps and introducing new ROCm expansions. AMD will continue to maintain
traditional ROCm releases in parallel with the 7.9+ preview stream.

(790-supported-hw)=
## Supported hardware and operating systems

ROCm 7.9.0 supports the following AMD Instinct GPUs and Ryzen AI
APUs. Each supported device is listed with its corresponding GPU architecture,
LLVM target, and supported operating systems.

```{note}
If you're running ROCm on Linux, ensure your system is using a
supported kernel version. Future preview releases will expand operating system
support coverage.
```

<table class="rocm-docs-table table">
	<thead>
		<tr class="row-odd">
			<th class="head">
				<p>AMD device series</p>
			</th>
			<th class="head">
				<p>Device</p>
			</th>
			<th class="head">
				<p>Architecture</p>
			</th>
			<th class="head">
				<p>LLVM target</p>
			</th>
			<th class="head">
				<p>Supported OS</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<th class="stub">
				<p>Instinct MI350 Series</p>
			</th>
			<td>
						<p>Instinct MI355X</p>
						<p>Instinct MI350X</p>
			</td>
			<td>
				<p>CDNA4</p>
			</td>
			<td>
				<p>gfx950</p>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>
					Ubuntu 24.04.3<br>(GA kernel: 6.8)<br><br>
					Ubuntu 22.04.5<br>(GA kernel: 5.15)<br><br>
					RHEL 10.0<br>(kernel: 6.12.0-55)<br><br>
					RHEL 9.6<br>(kernel: 5.14.0-570)
				</p>
			</td>
		</tr>
		<tr class="row-odd">
			<th class="stub">
				<p>Instinct MI300 Series</p>
			</th>
			<td>
						<p>Instinct MI325X</p>
						<p>Instinct MI300X</p>
						<p>Instinct MI300A</p>
			</td>
			<td>
				<p>CDNA3</p>
			</td>
			<td>
				<p>gfx942</p>
			</td>
		</tr>
		<tr class="row-even">
			<th class="stub">
				<p>Ryzen AI Max PRO 300 Series</p>
			</th>
			<td>
						<p>Ryzen AI Max+ PRO 395</p>
						<p>Ryzen AI Max PRO 390</p>
						<p>Ryzen AI Max PRO 385</p>
						<p>Ryzen AI Max PRO 380</p>
			</td>
			<td>
				<p>RDNA3.5</p>
			</td>
			<td>
				<p>gfx1151</p>
			</td>
			<td>
				<p>Ubuntu 24.04.3<br>(HWE kernel: 6.14)<br><br>Windows 11 24H2</p>
			</td>
		</tr>
		<tr class="row-odd">
			<th class="stub">
				<p>Ryzen AI Max 300 Series</p>
			</th>
			<td>
						<p>Ryzen AI Max+ 395</p>
						<p>Ryzen AI Max 390</p>
						<p>Ryzen AI Max 385</p>
			</td>
			<td>
				<p>RDNA3.5</p>
			</td>
			<td>
				<p>gfx1151</p>
			</td>
			<td>
				<p>Ubuntu 24.04.3<br>(HWE kernel: 6.14)<br><br>Windows 11 24H2</p>
			</td>
		</tr>
	</tbody>
</table>

```{note}
This release supports a limited number of GPU and APUs.
Hardware support will be expanded with future releases -- following the
six-week release cadence.
```

## Supported kernel driver and firmware bundles

ROCm depends on a coordinated stack of compatible firmware, driver, and user
space components. Maintaining version alignment between these layers ensures correct GPU
operation and performance, especially for AMD data center products.
While AMD publishes drivers and ROCm user space components, your server or
infrastructure provider publishes the GPU and baseboard firmware by bundling
AMD firmware releases through Platform Level Data Model (PLDM) bundles --
which include the Integrated Firmware Image (IFWI).

```{note}
- Supported Ryzen AI APUs require the inbox kernel driver included with Ubuntu
24.04.3.
- GPU virtualization is not supported in ROCm 7.9.0.
```

<table class="rocm-docs-table table">
	<thead>
		<tr class="row-odd">
			<th class="head">
				<p>AMD device</p>
			</th>
			<th class="head">
				<p>Linux driver</p>
			</th>
			<th class="head">
				<p>Adrenalin Driver (Windows)</p>
			</th>
			<th class="head">
				<p>PLDM bundle (firmware)</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<td>
				<p>Instinct MI355X</p>
			</td>
			<td rowspan="5" style="vertical-align: middle;">
				<p>AMD GPU Driver (amdgpu)<br>30.10<br>30.10.1<br>30.10.2</p>
			</td>
			<td rowspan="5" style="vertical-align: middle;">
				<p>Not applicable</p>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
						<p>01.25.15.04</p>
						<p>01.25.13.09</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Instinct MI350X</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Instinct MI325X</p>
			</td>
			<td style="vertical-align: middle;">
						<p>01.25.04.02</p>
						<p>01.25.03.03</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Instinct MI300X</p>
			</td>
			<td>
				<p>01.25.03.12</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Instinct MI300A</p>
			</td>
			<td>
						<p>BKC 26</p>
						<p>BKC 25</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Ryzen AI Max+ PRO 395</p>
			</td>
			<td rowspan="7" style="vertical-align: middle;">
				<p>Inbox kernel driver<br>in Ubuntu 24.04.3</p>
			</td>
			<td rowspan="7" style="vertical-align: middle;">
				<p>25.9.2</p>
			</td>
			<td rowspan="7" style="vertical-align: middle;">
				<p>Not applicable</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Ryzen AI Max PRO 390</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Ryzen AI Max PRO 385</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Ryzen AI Max PRO 380</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Ryzen AI Max+ 395</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Ryzen AI Max 390</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Ryzen AI Max 385</p>
			</td>
		</tr>
	</tbody>
</table>

## Deep learning frameworks

ROCm 7.9.0 supports PyTorch 2.7.1 on Linux and PyTorch 2.9.0 on Windows.

## ROCm Core SDK components

The following table lists core components included in the ROCm 7.9.0 release.
Expect future releases in this stream to expand the list of components.

<table class="rocm-docs-table table">
	<thead>
		<tr class="row-odd">
			<th class="head">
				<p>Component group</p>
			</th>
			<th class="head">
				<p>Component name</p>
			</th>
			<th class="head">
				<p>Supported operating systems</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<td rowspan="4" style="vertical-align: middle;">
				<p>Runtime and compilers</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/hip"><p>HIP</p></a>
			</td>
			<td rowspan="3" style="vertical-align: middle;">
				<p>Linux and Windows</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/HIPIFY/tree/therock-7.9.0"><p>HIPIFY</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/llvm-project/tree/therock-7.9.0"><p>LLVM</p></a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocr-runtime"><p>ROCr Runtime</p></a>
			</td>
			<td>
				<p>Linux</p>
			</td>
		</tr>
		<tr class="row-even">
			<td rowspan="2" style="vertical-align: middle;">
				<p>Control and monitoring</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/amdsmi/tree/therock-7.9.0"><p>AMD SMI</p></a>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>Linux</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocminfo"><p>rocminfo</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td rowspan="2" style="vertical-align: middle;">
				<p>System utilities, profiling, and debugging</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-cmake/tree/release/therock-7.9"><p>ROCm CMake</p></a>
			</td>
			<td>
				<p>Linux and Windows</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocprofiler-sdk"><p>ROCprofiler-SDK</p></a>
			</td>
			<td style="vertical-align: middle;">
				<p>Linux (Instinct GPUs only)</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td rowspan="15" style="vertical-align: middle;">
				<p>Math and compute libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocblas"><p>rocBLAS</p></a>
			</td>
			<td rowspan="14" style="vertical-align: middle;">
				<p>Linux and Windows</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblas"><p>hipBLAS</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblaslt"><p>hipBLASLt</p></a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocfft"><p>rocFFT</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipfft"><p>hipFFT</p></a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocrand"><p>rocRAND</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hiprand"><p>hipRAND</p></a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsolver"><p>rocSOLVER</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsolver"><p>hipSOLVER</p></a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsparse"><p>rocSPARSE</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsparse"><p>hipSPARSE</p></a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocprim"><p>rocPRIM</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocthrust"><p>rocThrust</p></a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipcub"><p>hipCUB</p></a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/miopen"><p>MIOpen</p></a>
			</td>
			<td>
				<p>Linux (Instinct GPUs only)</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Communication libraries</p>
			</td>
			<td>
				<a href="https://github.com/rocm/rccl"><p>RCCL</p></a>
			</td>
			<td>
				<p>Linux</p>
			</td>
		</tr>
	</tbody>
</table>

## Known issues

### Incorrect GPU architecture detection by CMake

On Windows, CMake does not automatically determine the correct GPU architecture
when configuring ROCm projects using TheRock.

- **Impact**: Applications may crash at runtime due to an incorrect offload target being selected.

- **Workaround**: Manually specify the target GPU architecture by setting the CMake flag `CMAKE_HIP_ARCHITECTURES`.

### clang build failure with -fgpu-rdc and -fuse-ld=lld-link

On Windows, builds may fail when using both the `-fgpu-rdc` and `-fuse-ld=lld-link`
compiler options together.

- **Impact**: Users are unable to build applications that require relocatable device code (`-fgpu-rdc`).

### No GPU detected when building Redshift or Blender with ROCm 7.9.0

When building custom Redshift or Blender binaries against ROCm 7.9.0, users may
encounter a “No GPU detected” error message. This issue does not occur with the
officially distributed Redshift and Blender binaries.

- **Impact**: Locally built versions of Redshift and Blender may fail to
  recognize available GPUs, preventing GPU-accelerated rendering.

## Upcoming changes

Future preview releases will expand support for:

* Additional ROCm Core SDK components

* Domain-specific Expansion SDKs (data science, life science, and more)

* Extended AMD hardware coverage

* GPU virtualization support
