.. matrix::

   .. matrix-head::

      .. matrix-row::
         :header:

         .. matrix-cell:: Framework

         .. matrix-cell:: Supported versions

         .. matrix-cell:: Python versions

   .. matrix-row::

      .. matrix-cell:: PyTorch

      .. matrix-cell:: 2.10.0, 2.9.1, 2.8.0
         :show-when: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: 2.10.0, 2.9.1
         :show-when: os=windows

      .. matrix-cell:: 3.13, 3.12, 3.11

   .. matrix-row::
      :show-when: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: JAX

      .. matrix-cell:: 0.8.2, 0.8.0

      .. matrix-cell:: 3.14, 3.13, 3.12, 3.11

   .. matrix-row::
      :show-when: os=ubuntu os=debian os=rhel os=oracle-linux os=rocky-linux os=sles

      .. matrix-cell:: vLLM
         :show-when: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x gpu=mi300a gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060 gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

      .. matrix-cell:: 0.16.0
         :show-when: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x gpu=mi300a gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060 gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385

      .. matrix-cell:: 3.12 (requires PyTorch 2.9.1)
         :show-when: gpu=mi355x gpu=mi350x gpu=mi325x gpu=mi300x gpu=mi300a gpu=ai-r9700 gpu=ai-r9600d gpu=rx-9070-xt gpu=rx-9070-gre gpu=rx-9070 gpu=rx-9060-xt-lp gpu=rx-9060-xt gpu=rx-9060 gpu=max-pro-395 gpu=max-pro-390 gpu=max-pro-385 gpu=max-pro-380 gpu=max-395 gpu=max-390 gpu=max-385
