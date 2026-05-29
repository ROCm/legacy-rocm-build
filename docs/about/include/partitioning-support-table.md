The following compute partition and NUMA-per-socket (NPS) configurations are
available on AMD Instinct GPUs in bare metal deployments.

<table class="rocm-docs-table table">
  <thead>
    <tr>
      <th class="head">
        <p>Deployment</p>
      </th>
      <th class="head">
        <p>Device</p>
      </th>
      <th class="head">
        <p>Compute partition mode</p>
      </th>
      <th class="head">
        <p>Memory partition mode</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="7" style="vertical-align: middle;">
        <p>Bare metal</p>
      </td>
      <td rowspan="3" style="vertical-align: middle;">
        <p>Instinct MI355X, MI350X</p>
      </td>
      <td>
        <p>CPX</p>
      </td>
      <td>
        <p>NPS2</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>DPX</p>
      </td>
      <td>
        <p>NPS2</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>QPX</p>
      </td>
      <td>
        <p>NPS2</p>
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="vertical-align: middle;">
        <p>Instinct MI350P</p>
      </td>
      <td>
        <p>CPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>SPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="vertical-align: middle;">
        <p>Instinct MI300X</p>
      </td>
      <td>
        <p>CPX</p>
      </td>
      <td>
        <p>NPS4</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>DPX</p>
      </td>
      <td>
        <p>NPS2</p>
      </td>
    </tr>
  </tbody>
</table>

The following configurations are available on AMD Instinct GPUs in SR-IOV
deployments. See {ref}`release-virtualization-support` for driver support
information.

<table class="rocm-docs-table table">
  <thead>
    <tr>
      <th class="head">
        <p>Deployment</p>
      </th>
      <th class="head">
        <p>Device</p>
      </th>
      <th class="head">
        <p>VFs per GPU</p>
      </th>
      <th class="head">
        <p>Compute partition mode</p>
      </th>
      <th class="head">
        <p>Memory partition mode</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="7" style="vertical-align: middle;">
        <p>KVM SR-IOV</p>
      </td>
      <td rowspan="3" style="vertical-align: middle;">
        <p>Instinct MI355X, MI350X</p>
      </td>
      <td rowspan="3" style="vertical-align: middle;">
        <p>1</p>
      </td>
      <td>
        <p>SPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>CPX</p>
      </td>
      <td>
        <p>NPS2</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>DPX</p>
      </td>
      <td>
        <p>NPS2</p>
      </td>
    </tr>
    <tr>
      <td style="vertical-align: middle;">
        <p>Instinct MI325X</p>
      </td>
      <td>
        <p>1</p>
      </td>
      <td>
        <p>SPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="vertical-align: middle;">
        <p>Instinct MI300X (preview)</p>
      </td>
      <td>
        <p>1</p>
      </td>
      <td>
        <p>SPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
    <tr id="id1">
      <td>
        <p>8
        <a class="footnote-reference brackets" href="#partitioning-support-footnotes" role="doc-noteref"><span class="fn-bracket">[</span>*<span class="fn-bracket">]</span></a></p>
      </td>
      <td>
        <p>CPX</p>
      </td>
      <td>
        <p>NPS4</p>
      </td>
    </tr>
  </tbody>
</table>

<aside class="footnote brackets" id="partitioning-support-footnotes" role="doc-footnote">
<span id="#fn1" class="label"><span class="fn-bracket">[</span><a href="#id1" role="doc-backlink">*</a><span class="fn-bracket">]</span></span>
<p>Multi-VF (8 VF) support requires a compatible firmware. See <a href="#kernel-driver-and-firmware-bundle-support">Kernel driver and firmware bundle support</a> for the list of required firmware versions and supported configurations.</p>
</aside>
