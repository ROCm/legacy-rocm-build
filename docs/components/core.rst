.. meta::
   :description: AMD ROCm Core SDK - list of libraries and tools
   :keywords: component, tool, lib, library, dnn, algorithm, cli, end, machine, learning, optimization, optimize, primitive, api, binding, wrapper

************************
ROCm Core SDK components
************************

The ROCm Core SDK is the foundation of the ROCm software stack. It provides the
libraries, runtimes, compilers, and tools needed to develop and run GPU-accelerated
applications on AMD hardware.

.. datatemplate:yaml:: /_data/components.yaml

    {%- set components = data.rocm_core_sdk.components -%}
    {%- set version_slug = data.rocm_core_sdk.meta.rtd_version_slug -%}
    {%- set release_tag = data.rocm_core_sdk.meta.release_tag -%}
    {%- set base_url = "https://rocm.docs.amd.com/projects" -%}
    {%- set group_order = [
        "Math and compute libraries",
        "Communication libraries",
        "Runtime and compilers",
        "Profiling and debugging tools",
        "Control and monitoring tools",
        "Media libraries",
        "Storage"
    ] -%}

    {# Collect groups not in the predefined order so they appear at the end. #}
    {%- set extra_groups = [] -%}
    {%- for name, comp in components.items() -%}
    {%-     if comp.group is defined and comp.group not in group_order and comp.group not in extra_groups -%}
    {%-         set _ = extra_groups.append(comp.group) -%}
    {%-     endif -%}
    {%- endfor -%}

    {%- for group in group_order + extra_groups -%}
    {%-     set group_items = [] -%}
    {%-     for name, comp in components.items() -%}
    {%-         if comp.group is defined and comp.group == group -%}
    {%-             set _ = group_items.append((name, comp)) -%}
    {%-         endif -%}
    {%-     endfor -%}
    {%-     if group_items %}

    {{ group }}
    {{ "=" * group | length }}
    {%- if group == "Math and compute libraries" %}

    A comprehensive set of GPU-accelerated math libraries covering dense and sparse
    linear algebra, FFTs, random number generation, and more.

    * Libraries prefixed with ``roc*`` are native, high-performance
      implementations written in HIP specifically for AMD GPUs.

    * Libraries prefixed with ``hip*`` are portable wrappers that implement
      NVIDIA CUDA-equivalent APIs, allowing CUDA applications to be ported to AMD GPUs
      with minimal code changes.

    Libraries include:
    {% endif %}
    {%- for name, comp in group_items | sort(attribute="0") -%}
    {%-     if comp.xref is defined and comp.xref.rtd_project is defined -%}
    {%-         set link = base_url + "/" + comp.xref.rtd_project + "/en/" + version_slug -%}
    {%-     elif comp.xref is defined and comp.xref.github_repo is defined -%}
    {%-         if comp.xref.github_repo.startswith("https://") -%}
    {%-             set link = comp.xref.github_repo + "/tree/" + release_tag -%}
    {%-         else -%}
    {%-             set link = "https://github.com/ROCm/" + comp.xref.github_repo + "/tree/" + release_tag -%}
    {%-         endif -%}
    {%-     else -%}
    {%-         set link = None -%}
    {%-     endif -%}
    {%-     set desc = " -- " + comp.description if comp.description is defined else "" -%}
    {%-     if link %}
    * `{{ name }} <{{ link }}>`__{{ desc }}
    {%-     else %}
    * {{ name }}{{ desc }}
    {%-     endif %}
    {%- endfor %}
    {%-     endif -%}
    {%- endfor %}
