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
      <td rowspan="11" style="vertical-align: middle;">
        <p>Bare metal</p>
      </td>
      <td rowspan="4" style="vertical-align: middle;">
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
      <td>
        <p>SPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="vertical-align: middle;">
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
        <p>DPX</p>
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
      <td style="vertical-align: middle;">
        <p>Instinct MI325X</p>
      </td>
      <td>
        <p>SPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="vertical-align: middle;">
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
    <tr>
      <td>
        <p>SPX</p>
      </td>
      <td>
        <p>NPS1</p>
      </td>
    </tr>
  </tbody>
</table>

The following compute partition and NUMA-per-socket (NPS) configurations are
available on AMD Instinct GPUs in passthrough deployments.

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
      <td style="vertical-align: middle;">
        <p>KVM Passthrough</p>
      </td>
      <td style="vertical-align: middle;">
        <p>Instinct MI355X, MI350X, MI325X, MI300X</p>
      </td>
      <td rowspan="2" style="vertical-align: middle;">
        <p>SPX</p>
      </td>
      <td rowspan="2" style="vertical-align: middle;">
        <p>NPS1</p>
      </td>
    </tr>
    <tr>
      <td style="vertical-align: middle;">
        <p>ESXi Passthrough</p>
      </td>
      <td style="vertical-align: middle;">
        <p>Instinct MI350P, MI300X</p>
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
      <td rowspan="6" style="vertical-align: middle;">
        <p>KVM SR-IOV</p>
      </td>
      <td rowspan="3" style="vertical-align: middle;">
        <p>Instinct MI355X, MI350X</p>
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
      <td>
        <p>8<a id="id2" class="footnote-reference brackets" href="#partitioning-support-footnotes" role="doc-noteref"><span class="fn-bracket">[</span>*<span class="fn-bracket">]</span></a></p>
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
        <p>2<a id="id2" class="footnote-reference brackets" href="#partitioning-support-footnotes" role="doc-noteref"><span class="fn-bracket">[</span>*<span class="fn-bracket">]</span></a></p>
      </td>
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
        <p>Instinct MI300X</p>
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
        <p>8<a id="id2" class="footnote-reference brackets" href="#partitioning-support-footnotes" role="doc-noteref"><span class="fn-bracket">[</span>*<span class="fn-bracket">]</span></a></p>
      </td>
      <td>
        <p>CPX</p>
      </td>
      <td>
        <p>NPS4</p>
      </td>
    </tr>
    <tr>
      <td style="vertical-align: middle;">
        <p>ESXi SR-IOV</p>
      </td>
      <td style="vertical-align: middle;">
        <p>Instinct MI355X, Instinct MI350X</p>
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
  </tbody>
</table>

<aside class="footnote brackets" id="partitioning-support-footnotes" role="doc-footnote">
<span id="#fn2" class="label"><span class="fn-bracket">[</span><a href="#id2" role="doc-backlink">*</a><span class="fn-bracket">]</span></span>
<p>Multi-VF support requires a compatible firmware. See <a href="#kernel-driver-and-firmware-bundle-support">Kernel driver and firmware bundle support</a> for the list of required firmware versions and supported configurations.</p>
</aside>
