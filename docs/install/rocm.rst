.. meta::
   :description: How to install AMD ROCm for Instinct GPUs, Radeon GPUs, and Ryzen AI APUs
   :keywords: linux, distro, windows, install, download, setup, quick, start, amdgpu-install, pkg, package, meta, ubuntu, debian, red, hat, rhel, suse, sles, enterprise, server, oracle, azure, centos, rocky, fedora, void, arch, cachy, pop, mint, tar

:selector-toc2: Installation environment
:selector-toc2-icon: fa-solid fa-computer

*******************************
Install AMD ROCm |ROCM_VERSION|
*******************************

.. _rocm-install-selector:

Use the following selector to choose your installation method for your
supported AMD GPU or APU and operating system. For system requirements and
support information, see the :doc:`Compatibility matrix
</compatibility/compatibility-matrix>`. To learn more about changes introduced
in ROCm |ROCM_VERSION|, see the :doc:`Release notes </about/release-notes>`.

.. note::

   If your GPU is not listed, it might be community-enabled through TheRock
   nightly builds. For more information, see `TheRock supported GPUs
   <https://github.com/ROCm/TheRock/blob/main/SUPPORTED_GPUS.md>`__. For
   installation guidance, see `TheRock releases
   <https://github.com/ROCm/TheRock/blob/main/RELEASES.md>`__.

.. include:: ./include/fam-multi-arch-selector.rst

.. include:: ./include/gpu-selector.rst

.. include:: ./include/os-selector.rst

.. include:: ./include/ror-gpu-selector.rst

.. include:: ./include/ubuntu-ver-selector.rst

.. include:: ./include/debian-ver-selector.rst

.. include:: ./include/rhel-ver-selector.rst

.. include:: ./include/oracle-linux-ver-selector.rst

.. include:: ./include/rocky-linux-ver-selector.rst

.. include:: ./include/sles-ver-selector.rst

.. include:: ./include/windows-ver-selector.rst

.. include:: ./include/install-method-selector.rst

----

.. _rocm-install-about:

.. include:: ./include/000-intro.rst

----

.. _rocm-prerequisites:

.. include:: ./include/100-prerequisites.rst

.. include:: ./include/150-runfile-quick-start-config-options.rst

----

.. _rocm-install:

.. include:: ./include/200-install.rst

----

.. _rocm-post-install:

.. include:: ./include/300-post-install.rst

----

.. _rocm-uninstall:

.. include:: ./include/400-uninstall.rst

|
|
|
|
|
|
|
|
|

.. raw:: html

   <script>
     document.addEventListener("DOMContentLoaded", () => {
       const nextLink = document.querySelector("footer.prev-next-footer a.right-next");
       const nextTitle = nextLink.querySelector(".prev-next-title");
       nextTitle.textContent = "Build the ROCm Core SDK from source";
       nextLink.href = "./build-from-source.html";
     });
   </script>
