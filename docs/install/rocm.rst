.. meta::
   :description: Learn how to install AMD ROCm 7.11.0 for supported Instinct GPUs and Ryzen AI APUs on Ubuntu, RHEL, and Windows. This step-by-step guide covers prerequisites, driver setup, installation methods (pip and tarball), and troubleshooting.
   :keywords: AMD ROCm 7.11.0, install ROCm, Instinct GPU, Ryzen APU, Ubuntu, RHEL, Windows, pip install ROCm, ROCm wheel, ROCm tarball, ROCm GPU driver, ROCm setup, ROCm uninstall, ROCm troubleshooting

*******************************
Install AMD ROCm |ROCM_VERSION|
*******************************

.. _rocm-install-selector:

Use the following selector to choose your installation method for your
supported AMD GPU or APU and operating system. For system requirements and
support information, see the :doc:`Compatibility matrix
</compatibility/compatibility-matrix>`. To learn more about changes introduced
in ROCm |ROCM_VERSION|, see the :doc:`Release notes </about/release-notes>`.

.. include:: ./includes/selector.rst

----

.. _rocm-prerequisites:

.. include:: ./includes/prerequisites.rst

----

.. _rocm-install:

.. include:: ./includes/install.rst

----

.. _rocm-post-install:

.. include:: ./includes/post-install.rst

----

.. _rocm-uninstall:

.. include:: ./includes/uninstall.rst

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
