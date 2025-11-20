# ROCm compatibility matrix

To plan your [ROCm 7.9.0 installation](/install/rocm), use the following selector to
view ROCm compatibility and system requirements information for your AMD
hardware configuration.

````{selector} AMD product family
:key: plat

```{selector-option} Instinct GPU
:value: instinct
:width: 6
```

```{selector-option} Ryzen APU
:value: ryzen
:width: 6
```
````

`````{selected} plat=instinct
````{selector} Instinct GPU
:key: instinct-arch

```{selector-option} Instinct MI355X, MI350X
:value: gfx950
```

```{selector-option} Instinct MI325X, MI300X, MI300A
:value: gfx942
```
````

````{selector} Operating system
:key: instinct-os

```{selector-option} Ubuntu
:value: ubuntu
:icon: fab fa-ubuntu fa-lg
```

```{selector-option} Red Hat Enterprise Linux
:value: rhel
:icon: fab fa-redhat fa-lg
```
````
`````

`````{selected} plat=ryzen
````{selector} Ryzen APU
:key: ryzen-arch

```{selector-option} Ryzen AI Max+ PRO 395<br>Ryzen AI Max PRO 390, 385, 380
:value: ryzen-ai-max-pro
:width: 7
```

```{selector-option} Ryzen AI Max+ 395<br>Ryzen AI Max 390, 385
:value: ryzen-ai-max
:width: 5
```
````

````{selector} Operating system
:key: ryzen-os

```{selector-option} Ubuntu
:value: ubuntu
:icon: fab fa-ubuntu fa-lg
```

```{selector-option} Windows
:value: windows
:icon: fab fa-windows fa-lg
```
````
`````

## Hardware, software, and firmware requirements

ROCm depends on a coordinated stack of compatible firmware, driver, and user
space components. Maintaining version alignment between these layers ensures
correct GPU operation and performance, especially for AMD data center products.
Future preview release will expand hardware and operating system coverage.

:::::{selected} plat=instinct
::::{selected} instinct-arch=gfx950
:::{selected} instinct-os=ubuntu
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Instinct MI350 Series</p>
            </th>
            <td>
                <p>Instinct MI355X, MI350X</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>CDNA4</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx950</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported Ubuntu versions</p>
            </th>
            <td>
                <p>Ubuntu 24.04.3 (GA kernel: 6.8)</p>
                <p>Ubuntu 22.04.5 (GA kernel: 5.15)</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>Supported AMD GPU Driver versions</p>
            </th>
            <td>
                <p>30.10, 30.10.1, 30.10.2</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported PLDM bundle (firmware) versions</p>
            </th>
            <td>
                <p>01.25.15.04, 01.25.13.09</p>
            </td>
        </tr>
    </tbody>
</table>
:::

:::{selected} instinct-os=rhel
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Instinct MI350 Series</p>
            </th>
            <td>
                <p>Instinct MI355X, MI350X</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>CDNA4</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx950</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported RHEL versions</p>
            </th>
            <td>
                <p>RHEL 10.0 (kernel: 6.12.0-55)</p>
                <p>RHEL 9.6 (kernel: 5.14.0-570)</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>Supported AMD GPU Driver versions</p>
            </th>
            <td>
                <p>30.10, 30.10.1, 30.10.2</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported PLDM bundle (firmware) versions</p>
            </th>
            <td>
                <p>01.25.15.04, 01.25.13.09</p>
            </td>
        </tr>
    </tbody>
</table>
:::
::::

::::{selected} instinct-arch=gfx942
:::{selected} instinct-os=ubuntu
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Instinct MI300 Series</p>
            </th>
            <td>
                <p>Instinct MI325X, MI300X, MI300A</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>CDNA3</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx942</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported Ubuntu versions</p>
            </th>
            <td>
                <p>Ubuntu 24.04.3 (GA kernel: 6.8)</p>
                <p>Ubuntu 22.04.5 (GA kernel: 5.15)</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>AMD GPU Driver versions</p>
            </th>
            <td>
                <p>30.10, 30.10.1, 30.10.2</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported PLDM bundle (firmware) versions</p>
            </th>
            <td>
                <p><strong>MI325X</strong>: 01.25.04.02, 01.25.03.03</p>
                <p><strong>MI300X</strong>: 01.25.03.12</p>
                <p><strong>MI300A</strong>: BKC 26, BKC 25</p>
            </td>
        </tr>
    </tbody>
</table>
:::

:::{selected} instinct-os=rhel
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Instinct MI300 Series</p>
            </th>
            <td>
                <p>Instinct MI325X, MI300X, MI300A</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>CDNA3</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx942</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported RHEL versions</p>
            </th>
            <td>
                <p>RHEL 10.0 (kernel: 6.12.0-55)</p>
                <p>RHEL 9.6 (kernel: 5.14.0-570)</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>AMD GPU Driver versions</p>
            </th>
            <td>
                <p>30.10, 30.10.1, 30.10.2</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported PLDM bundle (firmware) versions</p>
            </th>
            <td>
                <p><strong>MI325X</strong>: 01.25.04.02, 01.25.03.03</p>
                <p><strong>MI300X</strong>: 01.25.03.12</p>
                <p><strong>MI300A</strong>: BKC 26, BKC 25</p>
            </td>
        </tr>
    </tbody>
</table>
:::
::::
:::::

:::::{selected} plat=ryzen
::::{selected} ryzen-arch=ryzen-ai-max-pro
:::{selected} ryzen-os=ubuntu
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Ryzen AI Max PRO 300 Series</p>
            </th>
            <td>
                <p>Ryzen AI Max+ PRO 395</p>
                <p>Ryzen AI Max PRO 390, 385, 380</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>RDNA3.5</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx1151</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported Ubuntu version</p>
            </th>
            <td>
                <p>Ubuntu 24.04.3 (HWE kernel: 6.14)</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>Supported kernel driver version</p>
            </th>
            <td>
                <p>Inbox kernel driver in Ubuntu 24.04.3</p>
            </td>
        </tr>
    </tbody>
</table>
:::

:::{selected} ryzen-os=windows
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Ryzen AI Max PRO 300 Series</p>
            </th>
            <td>
                <p>Ryzen AI Max+ PRO 395</p>
                <p>Ryzen AI Max 390, 385, 380</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>RDNA3.5</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx1151</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported Windows version</p>
            </th>
            <td>
                <p>Windows 11 24H2</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>Supported Adrenalin Driver version</p>
            </th>
            <td>
                <p>25.9.2</p>
            </td>
        </tr>
    </tbody>
</table>
:::
::::

::::{selected} ryzen-arch=ryzen-ai-max
:::{selected} ryzen-os=ubuntu
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Ryzen AI Max 300 Series</p>
            </th>
            <td>
                <p>Ryzen AI Max+ 395</p>
                <p>Ryzen AI Max 390, 385</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>RDNA3.5</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx1151</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported Ubuntu version</p>
            </th>
            <td>
                <p>Ubuntu 24.04.3 (HWE kernel: 6.14)</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>Supported kernel driver version</p>
            </th>
            <td>
                <p>Inbox kernel driver in Ubuntu 24.04.3</p>
            </td>
        </tr>
    </tbody>
</table>
:::

:::{selected} ryzen-os=windows
<table class="rocm-docs-table table">
    <tbody>
        <tr class="row-odd">
            <th class="head" style="width: 50%">
                <p>AMD Ryzen AI Max 300 Series</p>
            </th>
            <td>
                <p>Ryzen AI Max+ 395</p>
                <p>Ryzen AI Max 390, 385</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Architecture</p>
            </th>
            <td>
                <p>RDNA3.5</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>LLVM target</p>
            </th>
            <td>
                <p>gfx1151</p>
            </td>
        </tr>
        <tr class="row-even">
            <th class="head">
                <p>Supported Windows version</p>
            </th>
            <td>
                <p>Windows 11 24H2</p>
            </td>
        </tr>
        <tr class="row-odd">
            <th class="head">
                <p>Supported Adrenalin Driver version</p>
            </th>
            <td>
                <p>25.9.2</p>
            </td>
        </tr>
    </tbody>
</table>
:::
::::
:::::

## Deep learning frameworks

::::{selected} plat=instinct
ROCm 7.9.0 supports PyTorch 2.7.1 on Instinct data center GPUs. See
{ref}`790-install-pyt` for an example installation using pip.
::::

::::{selected} plat=ryzen
:::{selected} ryzen-os=ubuntu
ROCm 7.9.0 supports PyTorch 2.7.1 on Ubuntu on supported Ryzen APUs. See
{ref}`790-install-pyt` for an example installation using pip.
:::

:::{selected} ryzen-os=windows
ROCm 7.9.0 supports PyTorch 2.9.0 on Windows on supported Ryzen AI APUs. See
{ref}`790-install-pyt` for an example installation using pip.
:::
::::

## ROCm Core SDK components

:::{selected} plat=instinct
The following table lists ROCm Core SDK components supported on Instinct GPUs
and Linux in the ROCm 7.9.0 release. Additional components will be added in
future releases.

<table class="rocm-docs-table table">
    <thead>
        <tr class="row-odd">
            <th class="head">
                <p>Component group</p>
            </th>
            <th class="head">
                <p>Component name</p>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr class="row-even">
            <td rowspan="4">
                <p>Runtime and compilers</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/hip">
                    HIP
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/HIPIFY/tree/therock-7.9.0">
                    HIPIFY
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/llvm-project/tree/therock-7.9.0">
                    LLVM
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocr-runtime">
                    ROCr Runtime
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td rowspan="2">
                <p>Control and monitoring</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/amdsmi/tree/therock-7.9.0">
                    AMD SMI
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocminfo">
                    rocminfo
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td rowspan="2">
                <p>System utilities, profiling, and debugging</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-cmake/tree/release/therock-7.9">
                    ROCm CMake
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocprofiler-sdk">
                    ROCprofiler-SDK
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td rowspan="15">
                <p>Math and compute libraries</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocblas">
                    rocBLAS
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblas">
                    hipBLAS
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblaslt">
                    hipBLASLt
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocfft">
                    rocFFT
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipfft">
                    hipFFT
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocrand">
                    rocRAND
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hiprand">
                    hipRAND
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsolver">
                    rocSOLVER
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsolver">
                    hipSOLVER
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsparse">
                    rocSPARSE
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsparse">
                    hipSPARSE
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocprim">
                    rocPRIM
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocthrust">
                    rocThrust
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipcub">
                    hipCUB
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/miopen">
                    MIOpen
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <p>Communication libraries</p>
            </td>
            <td>
                <a href="https://github.com/rocm/rccl/tree/therock-7.9.0">
                    RCCL
                </a>
            </td>
        </tr>
    </tbody>
</table>
:::
::::{selected} plat=ryzen
:::{selected} ryzen-os=ubuntu
The following table lists ROCm Core SDK components supported on Ryzen AI APUs
and Ubuntu in the ROCm 7.9.0 release. Additional components will be added in
future releases.

<table class="rocm-docs-table table">
    <thead>
        <tr class="row-odd">
            <th class="head">
                <p>Component group</p>
            </th>
            <th class="head">
                <p>Component name</p>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr class="row-even">
            <td rowspan="4">
                <p>Runtime and compilers</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/hip">
                    HIP
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/HIPIFY">
                    HIPIFY
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/llvm-project">
                    LLVM
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocr-runtime">
                    ROCr Runtime
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td rowspan="2">
                <p>Control and monitoring</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/amdsmi">
                    AMD SMI
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/rocminfo">
                    rocminfo
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <p>System utilities, profiling, and debugging</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-cmake">
                    ROCm CMake
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td rowspan="14">
                <p>Math and compute libraries</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocblas">
                    rocBLAS
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblas">
                    hipBLAS
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblaslt">
                    hipBLASLt
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocfft">
                    rocFFT
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipfft">
                    hipFFT
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocrand">
                    rocRAND
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hiprand">
                    hipRAND
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsolver">
                    rocSOLVER
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsolver">
                    hipSOLVER
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsparse">
                    rocSPARSE
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsparse">
                    hipSPARSE
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocprim">
                    rocPRIM
                </a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocthrust">
                    rocThrust
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipcub">
                    hipCUB
                </a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <p>Communication libraries</p>
            </td>
            <td>
                <a href="https://github.com/rocm/rccl">
                    RCCL
                </a>
            </td>
        </tr>
    </tbody>
</table>
:::
:::{selected} ryzen-os=windows
The following table lists ROCm Core SDK components supported on Ryzen AI APUs
and Windows in the ROCm 7.9.0 release. Additional components will be added in
future releases.

<table class="rocm-docs-table table">
    <thead>
        <tr class="row-odd">
            <th class="head">
                <p>Component group</p>
            </th>
            <th class="head">
                <p>Component name</p>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr class="row-even">
            <td rowspan="3">
                <p>Runtime and compilers</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-systems/tree/therock-7.9.0/projects/hip">HIP</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/HIPIFY">HIPIFY</a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/llvm-project">LLVM</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <p>System utilities, profiling, and debugging</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-cmake">ROCm CMake</a>
            </td>
        </tr>
        <tr class="row-even">
            <td rowspan="14">
                <p>Math and compute libraries</p>
            </td>
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocblas">rocBLAS</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblas">hipBLAS</a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipblaslt">hipBLASLt</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocfft">rocFFT</a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipfft">hipFFT</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocrand">rocRAND</a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hiprand">hipRAND</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsolver">rocSOLVER</a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsolver">hipSOLVER</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocsparse">rocSPARSE</a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipsparse">hipSPARSE</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocprim">rocPRIM</a>
            </td>
        </tr>
        <tr class="row-even">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/rocthrust">rocThrust</a>
            </td>
        </tr>
        <tr class="row-odd">
            <td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/therock-7.9.0/projects/hipcub">hipCUB</a>
            </td>
        </tr>
    </tbody>
</table>
:::
::::
