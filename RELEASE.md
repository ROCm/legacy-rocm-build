# ROCm Core SDK 7.10.0 release notes

ROCm Core SDK 7.10.0 continues the technology preview release stream that began
with [ROCm
7.9.0](https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html),
advancing the transition to the new [TheRock](https://github.com/rocm/therock)
build and release system. To learn more about TheRock, see [ROCm Core SDK and
TheRock Build
System](https://rocm.blogs.amd.com/software-tools-optimization/therock/README.html).

This release expands AMD GPU and APU support coverage and adds more components
to the ROCm Core SDK. Developers can expect a more consistent build experience
and streamlined workflows that pave the way toward modular future ROCm
releases planned for 2026.

(preview-stream-note)=
```{important}
ROCm 7.10.0 follows the [versioning discontinuity that began with
7.9.0](https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html#preview-stream-note)
and remains separate from the 7.0 and 7.1 production releases. For the latest
production stream release, see the [ROCm
documentation](https://rocm.docs.amd.com/en/latest/).

Maintaining parallel release streams -- preview and production -- gives users
ample time to evaluate and adopt the new build system and dependency changes.
The technology preview stream is planned to continue through mid‑2026, after
which it will replace the current production stream.
```

## Release highlights

This preview of the ROCm Core SDK with TheRock introduces several improvements
following the previous 7.9.0 release, including expanded hardware support,
operating system coverage, and additional ROCm Core SDK components.

### Expanded AMD hardware support

ROCm 7.10.0 builds on ROCm 7.9.0, adding new support for the following AMD Instinct
GPUs and Ryzen AI APUs:

* Instinct MI250X

* Instinct MI250

* Instinct MI210

* Radeon PRO W7900D

* Radeon PRO W7900

* Radeon PRO W7800 48GB

* Radeon PRO W7800

* Radeon PRO W7700

* Radeon RX 7900 XTX

* Radeon RX 7900 XT

* Radeon RX 7900 GRE

* Radeon RX 7800 XT

* Radeon RX 7700 XT

* Ryzen AI 9 HX 375

* Ryzen AI 9 HX 370

* Ryzen AI 9 365

For the full list of supported GPUs and APUs, see [Supported hardware and
operating systems](#release-supported-hw).

### Expanded Linux distribution support on Instinct GPUs

ROCm 7.10.0 builds on ROCm 7.9.0, adding new support for the following Linux
distributions on AMD Instinct MI350 Series, MI300 Series, and MI200 Series
GPUs.

- Red Hat Enterprise Linux (RHEL) 10.1, 10.0, 9.7, 9.6, and 8.10

- SUSE Linux Enterprise Server (SLES) 15.7

For the full list of supported operating system versions, see [Supported
hardware and operating systems](#release-supported-hw).

### Expanded ROCm Core SDK components

ROCm 7.10.0 adds the following tools and libraries to the ROCm Core SDK:

* **System utilities, profiling, and debugging tools**: ROCm Compute Profiler
  and SPIRV-LLVM-Translator

* **Math and compute libraries**: hipSPARSELt, Composable Kernel, and
  rocWMMA

### Compatibility notices

In terms of package compatibility, ROCm 7.10.0 diverges from the existing ROCm
7.0 stream and upcoming stable releases in that stream:

* **Compute-focused**: ROCm 7.10.0 enables support for primarily compute workloads.
  Future releases will support mixed workloads (compute and graphics).

  If you’re interested in testing AMD Radeon GPUs with preview support for
  graphics use cases with AMD ROCm 7.10.0, install Radeon Software for Linux
  version 25.30.1 from [Linux Drivers for AMD Radeon and Radeon PRO
  Graphics](https://www.amd.com/en/support/download/linux-drivers.html).

  If you're interested in testing AMD Ryzen APUs with preview support for
  graphics use cases with AMD ROCm 7.10.0, use the inbox graphics drivers of
  Ubuntu 24.04.3.

* **No upgrade path from existing production releases** including ROCm 7.1.1
  and earlier, as well as from upcoming stable releases. See the [explanatory
  note](#preview-stream-note).

* **Not intended for production workloads**: users running production environments should continue using the [ROCm 7.0 stream](https://rocm.docs.amd.com/en/latest/).
  See the [explanatory note](#preview-stream-note).

* **Not fully featured**: this release is a stepping stone toward fully open
  software development.

* **Limited hardware support**: preview releases are only supported on some AMD Instinct GPUs,
  Radeon GPUs, and Ryzen APUs. See [Supported hardware and operating
  systems](#supported-hardware-and-operating-systems).

* **Packaging formats**: RPM and Debian packages are not available in this
  release. Instead, Python wheels and tarballs are provided. See the [ROCm 7.10.0
  installation instructions](/install/rocm).

* **Software components**: some components of the ROCm Core SDK are not yet
  available in this release. Additional components are planned to be introduced
  in future preview releases as part of the ROCm Core SDK. Other libraries and
  tools not included in the future Core SDK will either be:
  * Released as standalone project-specific packages, or
  * Grouped into domain-specific toolkits.

### Looking ahead

Subsequent technology preview releases will follow a 6-week cadence, filling
gaps and introducing new ROCm expansions. AMD continues to maintain traditional
ROCm releases in parallel with the preview stream until mid-2026.

(release-supported-hw)=
## Supported hardware and operating systems

ROCm 7.10.0 adds support for Instinct MI200 Series GPUs and Ryzen AI Series
APUs. The following table lists supported AMD Instinct GPUs, Radeon GPUs, and
Ryzen AI APUs. Each supported device is listed with its corresponding GPU
architecture, LLVM target, and supported operating systems.

```{note}
If you're running ROCm on Linux, ensure your system is using a
supported kernel version. Future preview releases will expand operating system
support coverage.
```

````{tab-set}
```{tab-item} Instinct
:sync: instinct

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
				<p>LLVM target</p>
			</th>
			<th class="head">
				<p>Architecture</p>
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
				<p>gfx950</p>
			</td>
			<td>
				<p>CDNA 4</p>
			</td>
			<td rowspan="3" style="vertical-align: middle;">
				<p>
					Ubuntu 24.04.3<br>(GA kernel: 6.8)<br><br>
					Ubuntu 22.04.5<br>(GA kernel: 5.15)<br><br>
					RHEL 10.1<br>(kernel: 6.12.0-124)<br><br>
					RHEL 10.0<br>(kernel: 6.12.0-55)<br><br>
					RHEL 9.7<br>(kernel: 5.14.0-611)<br><br>
					RHEL 9.6<br>(kernel: 5.14.0-570)<br><br>
					RHEL 8.10<br>(kernel: 4.18.0-553)<br><br>
					SLES 15.7<br>(kernel: 6.4.0-150700.51)
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
				<p>gfx942</p>
			</td>
			<td>
				<p>CDNA 3</p>
			</td>
		</tr>
		<tr class="row-odd">
			<th class="stub">
				<p>Instinct MI200 Series</p>
			</th>
			<td>
						<p>Instinct MI250X</p>
						<p>Instinct MI250</p>
						<p>Instinct MI210</p>
			</td>
			<td>
				<p>gfx90a</p>
			</td>
			<td>
				<p>CDNA 2</p>
			</td>
		</tr>
	</tbody>
</table>
```

```{tab-item} Radeon PRO
:sync: radeon-pro

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
				<p>LLVM target</p>
			</th>
			<th class="head">
				<p>Architecture</p>
			</th>
			<th class="head">
				<p>Supported OS</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<th rowspan="2" class="stub">
				<p>Radeon PRO W7000 Series</p>
			</th>
			<td>
						<p>Radeon PRO W7900D</p>
						<p>Radeon PRO W7900</p>
						<p>Radeon PRO W7800 48GB</p>
						<p>Radeon PRO W7800</p>
			</td>
			<td>
				<p>gfx1100</p>
			</td>
			<td rowspan="2">
				<p>RDNA 3</p>
			</td>
			<td rowspan="2">
				<p>Ubuntu 24.04.3<br>(HWE kernel: 6.14)<br><br>
                   Ubuntu 22.04.5<br>(HWE kernel: 6.8)<br><br>
                   Windows 11 25H2</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
						<p>Radeon PRO W7700</p>
			</td>
			<td>
				<p>gfx1101</p>
			</td>
		</tr>
	</tbody>
</table>
```

```{tab-item} Radeon RX
:sync: radeon

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
				<p>LLVM target</p>
			</th>
			<th class="head">
				<p>Architecture</p>
			</th>
			<th class="head">
				<p>Supported OS</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<th rowspan="2" class="stub">
				<p>Radeon RX 7000 Series</p>
			</th>
			<td>
						<p>Radeon RX 7900 XTX</p>
						<p>Radeon RX 7900 XT</p>
						<p>Radeon RX 7900 GRE</p>
			</td>
			<td>
				<p>gfx1100</p>
			</td>
			<td rowspan="2">
				<p>RDNA 3</p>
			</td>
			<td rowspan="2">
				<p>Ubuntu 24.04.3<br>(HWE kernel: 6.14)<br><br>
                   Ubuntu 22.04.5<br>(HWE kernel: 6.8)<br><br>
                   Windows 11 25H2</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
						<p>Radeon RX 7800 XT</p>
						<p>Radeon RX 7700 XT</p>
			</td>
			<td>
				<p>gfx1101</p>
			</td>
		</tr>
	</tbody>
</table>
```

```{tab-item} Ryzen AI
:sync: ryzen

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
				<p>LLVM target</p>
			</th>
			<th class="head">
				<p>Architecture</p>
			</th>
			<th class="head">
				<p>Supported OS</p>
			</th>
		</tr>
	</thead>
	<tbody>
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
			<td rowspan="2">
				<p>gfx1151</p>
			</td>
			<td rowspan="3">
				<p>RDNA 3.5</p>
			</td>
			<td rowspan="3">
				<p>Ubuntu 24.04.3<br>(HWE kernel: 6.14)<br><br>Windows 11 25H2</p>
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
		</tr>
		<tr class="row-odd">
			<th class="stub">
				<p>Ryzen AI 300 Series</p>
			</th>
			<td>
						<p>Ryzen AI 9 HX 375</p>
						<p>Ryzen AI 9 HX 370</p>
						<p>Ryzen AI 9 365</p>
			</td>
			<td>
				<p>gfx1150</p>
			</td>
		</tr>
	</tbody>
</table>
```
````

```{note}
This preview release supports a limited number of GPU and APUs. Hardware
support will be expanded with future releases, following a six-week release
cadence.
```

(release-supported-fw)=
## Supported kernel driver and firmware bundles

ROCm requires a coordinated stack of compatible firmware, driver, and user
space components. Maintaining version alignment between these layers ensures
correct GPU operation and performance, especially for AMD data center products.
While AMD publishes drivers and ROCm user space components, your server or
infrastructure provider publishes the GPU and baseboard firmware by bundling
AMD firmware releases through Platform Level Data Model (PLDM) bundles -- which
include the Integrated Firmware Image (IFWI).

```{note}
GPU virtualization is not supported in ROCm 7.10.0.
```

````{tab-set}
```{tab-item} Instinct
:sync: instinct

<table class="rocm-docs-table table">
	<thead>
		<tr class="row-odd">
			<th class="head">
				<p>AMD device</p>
			</th>
			<th class="head">
				<p>Firmware</p>
			</th>
			<th class="head">
				<p>Linux driver</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<td>
				<p>Instinct MI355X</p>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
						<p>PLDM bundle 01.25.15.04</p>
						<p>PLDM bundle 01.25.13.09</p>
			</td>
			<td rowspan="8" style="vertical-align: middle;">
				<p><strong>AMD GPU Driver (amdgpu)</strong><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/" target="_blank">30.20.0</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/" target="_blank">30.10.2</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/" target="_blank">30.10.1</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/" target="_blank">30.10.0</a>
                </p>
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
						<p>PLDM bundle 01.25.04.02</p>
						<p>PLDM bundle 01.25.03.03</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Instinct MI300X</p>
			</td>
			<td>
				<p>PLDM bundle 01.25.05.00 (or later)</p>
				<p>PLDM bundle 01.25.03.12</p>
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
		<tr class="row-even">
			<td>
				<p>Instinct MI250X</p>
			</td>
			<td>
						<p>IFWI 47 (or later)</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Instinct MI250</p>
			</td>
			<td rowspan="2">
						<p>Maintenance update 5 with IFWI 75 (or later)</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Instinct MI210</p>
			</td>
		</tr>
	</tbody>
</table>
```

```{tab-item} Radeon PRO
:sync: radeon-pro

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
				<p>Windows driver</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<td>
				<p>Radeon PRO W7900D</p>
			</td>
			<td rowspan="5" style="vertical-align: middle;">
				<p><strong>AMD GPU Driver (amdgpu)</strong><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/" target="_blank">30.20.0</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/" target="_blank">30.10.2</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/" target="_blank">30.10.1</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/" target="_blank">30.10.0</a>
                </p>
			</td>
			<td rowspan="5" style="vertical-align: middle;">
				<p><strong>AMD Software: Adrenalin Edition</strong><br>
                    <a href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-25-11-1.html" target="_blank">25.11.1</a> (generally recommended)<br>
                    <a href="https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-7-1-1.html" target="_blank">25.20.01.17</a> (recommended for ComfyUI)
                </p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon PRO W7900</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon PRO W7800 48GB</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon PRO W7800</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon PRO W7700</p>
			</td>
		</tr>
	</tbody>
</table>
```

```{tab-item} Radeon RX
:sync: radeon

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
				<p>Windows driver</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-even">
			<td>
				<p>Radeon RX 7900 XTX</p>
			</td>
			<td rowspan="5" style="vertical-align: middle;">
				<p><strong>AMD GPU Driver (amdgpu)</strong><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/" target="_blank">30.20.0</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/" target="_blank">30.10.2</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/" target="_blank">30.10.1</a><br>
                    <a href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/" target="_blank">30.10.0</a>
                </p>
			</td>
			<td rowspan="5" style="vertical-align: middle;">
				<p><strong>AMD Software: Adrenalin Edition</strong><br>
                    <a href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-25-11-1.html" target="_blank">25.11.1</a> (generally recommended)<br>
                    <a href="https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-7-1-1.html" target="_blank">25.20.01.17</a> (recommended for ComfyUI)
                </p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon RX 7900 XT</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon RX 7900 GRE</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon RX 7800 XT</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<p>Radeon RX 7700 XT</p>
			</td>
		</tr>
	</tbody>
</table>
```

```{tab-item} Ryzen AI
:sync: ryzen

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
				<p>Windows driver</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr class="row-odd">
			<td>
				<p>Ryzen AI Max+ PRO 395</p>
			</td>
			<td rowspan="10" style="vertical-align: middle;">
				<p>Inbox kernel driver<br>in Ubuntu 24.04.3</p>
			</td>
			<td rowspan="10" style="vertical-align: middle;">
				<p><strong>AMD Software: Adrenalin Edition</strong><br>
                    <a href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-25-11-1.html" target="_blank">25.11.1</a> (generally recommended)<br>
                    <a href="https://www.amd.com/en/resources/support-articles/release-notes/RN-AMDGPU-WINDOWS-PYTORCH-7-1-1.html" target="_blank">25.20.01.17</a> (recommended for ComfyUI)
                </p>
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
		<tr class="row-odd">
			<td>
				<p>Ryzen AI 9 HX 375</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Ryzen AI 9 HX 370</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<p>Ryzen AI 9 365</p>
			</td>
		</tr>
	</tbody>
</table>
```
````

## Deep learning frameworks

ROCm 7.10.0 provides optimized support for popular deep learning frameworks.
The following table lists supported frameworks, their compatible operating
systems, and validated framework versions.

<table class="rocm-docs-table table">
	<thead>
		<tr>
			<th class="head">
				<p>Framework</p>
			</th>
			<th class="head">
				<p>Supported OS</p>
			</th>
			<th class="head">
				<p>Supported framework versions</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan="2" style="vertical-align: middle;">
				<p>PyTorch</p>
			</td>
			<td>
				<p>Linux</p>
			</td>
			<td style="vertical-align: middle;">
				<p>2.9.1, 2.8.0, 2.7.1</p>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>Windows</p>
			</td>
			<td style="vertical-align: middle;">
				<p>2.9.1</p>
			</td>
		</tr>
    </tbody>
<table>

## ROCm Core SDK components

The following table lists core components included in the ROCm 7.10.0 release.
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
			<td rowspan="5" style="vertical-align: middle;">
				<p>Runtime and compilers</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.10/projects/hip">HIP</a>
			</td>
			<td rowspan="3" style="vertical-align: middle;">
				<p>Linux and Windows</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/HIPIFY/tree/therock-7.10">HIPIFY</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/llvm-project/tree/therock-7.10">LLVM</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.10/projects/rocr-runtime">ROCr Runtime</a>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>Linux</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/SPIRV-LLVM-Translator/tree/therock-7.10">SPIRV-LLVM-Translator</a>
			</td>
		</tr>
		<tr class="row-even">
			<td rowspan="3" style="vertical-align: middle;">
				<p>Control and monitoring tools</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/amdsmi/tree/release/therock-7.10">AMD SMI</a>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>Linux</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.10/projects/rocminfo">rocminfo</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
                <p>hipinfo</p>
			</td>
			<td>
				<p>Windows</p>
			</td>
		</tr>
		<tr class="row-even">
			<td rowspan="2" style="vertical-align: middle;">
				<p>Profiling and debugging tools</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.10/projects/rocprofiler-compute">ROCm Compute Profiler<br>(rocprofiler-compute)</a>
			</td>
			<td style="vertical-align: middle;">
				<p>Linux</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/therock-7.10/projects/rocprofiler-sdk">ROCprofiler-SDK</a>
			</td>
			<td style="vertical-align: middle;">
				<p>Linux (Instinct GPUs only)</p>
			</td>
        </tr>
		<tr class="row-odd">
			<td rowspan="18" style="vertical-align: middle;">
				<p>Math and compute libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocblas">rocBLAS</a>
			</td>
			<td rowspan="15" style="vertical-align: middle;">
				<p>Linux and Windows</p>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hipblas">hipBLAS</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hipblaslt">hipBLASLt</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocfft">rocFFT</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hipfft">hipFFT</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocrand">rocRAND</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hiprand">hipRAND</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocsolver">rocSOLVER</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hipsolver">hipSOLVER</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocsparse">rocSPARSE</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hipsparse">hipSPARSE</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocprim">rocPRIM</a>
			</td>
		</tr>
		<tr class="row-even">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocthrust">rocThrust</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hipcub">hipCUB</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/rocwmma">rocWMMA</a>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/hipsparselt">hipSPARSELt</a>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>Linux</p>
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/composablekernel">Composable Kernel</a><br>(partial, limited support)
			</td>
		</tr>
		<tr class="row-odd">
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.10/projects/miopen">MIOpen</a>
			</td>
			<td>
				<p>Linux (Instinct GPUs only)</p>
            </td>
        </tr>
        <tr class="row-odd">
			<td style="vertical-align: middle;">
				<p>Communication libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rccl/tree/release/therock-7.10">RCCL</a>
			</td>
			<td style="vertical-align: middle;">
				<p>Linux</p>
			</td>
		</tr>
		<tr class="row-even">
			<td style="vertical-align: middle;">
				<p>Support libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-cmake/tree/therock-7.10">ROCm CMake</a>
			</td>
			<td>
				<p>Linux and Windows</p>
			</td>
		</tr>
	</tbody>
</table>

## Known issues

The following sections describe some known issues identified in ROCm 7.10.0.

### PyTorch float64 test failures

The PyTorch unit test `test_reduction_fns_name_softmax_float64` might fail when
using the `float64` data type. This issue will be fixed in a future release.

### PyTorch binary ufunc test failures

Multiple tests in `test_binary_ufuncs` (for example, `pow_cuda_complex64` and
related slicing tests) might fail when using TheRock package.

(comfyui-driver-known-issue)=
### ComfyUI hangs on Windows when using older drivers

When running ComfyUI-based AI workflows on Windows using the TheRock packages
and Adrenalin driver 25.11.1, Timeout Detection and Recovery (TDR) events may
occur. As a workaround, use the Adrenalin driver 25.20.01.17 as noted in
[Supported kernel driver and firmware bundles](#release-supported-fw) for
stable ComfyUI model use.

### Wan2.2 14B video generation hangs on Windows

Running Wan2.2 14B video generation workflows in ComfyUI on Windows might
trigger Timeout Detection and Recovery (TDR) events and unusable output. This
issue will be fixed in a future release. As a workaround, avoid large-scale
video generation workloads on Windows for now.

### Long-duration inference workloads hang on Windows

Long-duration inference workloads (for example, Stable Diffusion or Llama
models) might cause hangs or system unresponsiveness, requiring a reboot. This
issue will be fixed in a future release. As a workaround, avoid long-duration
inference workloads on Windows for now.

### MIOpen incorrect results

On Ryzen AI Max 300 Series APUs, MIOpen might produce incorrect results due to
solvers that don't support non-packed tensors. This issue will be fixed in
a future release.

### MIOpen smoke test failures

MIOpen unit tests `Smoke/CPU_UnitTestImplicitGemmCKUtil_NONE.TestParsing/0` and
`TestParsing/5` might fail on TheRock builds. This issue will be fixed in
a future release.

### ROCr unit test failures

`rocrtstFunc.Concurrent_Init_Shutdown_Test` test hangs intermittently and can
cause timeouts or segmentation faults under specific system configurations (for
example, MI325X or Ryzen AI Max 300 Series APUs on Ubuntu 22.04).

### Build failures in HIP samples and rocrtst tests

Some HIP samples and rocrtst tests fail to build due to differences between
TheRock and legacy ROCm build environments. As a workaround, set the
environment variable before building: `export CXX=hipcc`.

### HIP-based, LDS, and SPIR-V test failures

Tests related to HIP-based, LDS, and SPIR-V fail with segmentation faults. This
issue will be fixed in a future release.

### Intermittent soft hangs related to HIP

HIP-directed Catch2 tests result in intermittent soft hangs, resulting in
a low-frequency reliability risk during execution. This will be fixed in
a future release. As a workaround, upgrade to newer drivers as they become
available to mitigate potential occurrences.

### Intermittent failures in KFD tests when using older drivers

KFD tests might intermittently fail when using ROCm 7.10.0 user-space
components with older kernel drivers (for example, ROCm 6.4 drivers) due to
feature mismatches. As a workaround, upgrade to the latest drivers as noted in
[Supported kernel driver and firmware bundles](#release-supported-fw) for
stability.

### PyTorch DDP with RCCL failures

Distributed training across multiple nodes on Instinct MI325X clusters using
PyTorch DistributedDataParallel (DDP) with RCCL might fail with collective
operation timeout errors or mismatched parameter shapes. This issue will be
fixed in a future release.

### HIP runtime error on PyTorch DDP with RCCL

PyTorch unit test `DistributedDataParallelTest.test_failure_recovery` fails
with a HIP runtime error `invalid device ordinal` when running RCCL-based
distributed tests on TheRock builds. This issue will be fixed in a future release.

## Upcoming changes

Future preview releases will expand support for:

* Additional ROCm Core SDK components

* Domain-specific Expansion Toolkits (data science, life science, finance,
  simulation, and other HPC domains)

* Extended AMD hardware coverage

* GPU virtualization support

