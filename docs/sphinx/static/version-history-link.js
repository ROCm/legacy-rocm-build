function ready(callback) {
  if (document.readyState !== "loading") {
    callback();
    return;
  }
  document.addEventListener("DOMContentLoaded", callback);
}

ready(() => {
  const versionListLink = document.querySelector(
    "a.header-all-versions[href='https://rocm.docs.amd.com/en/latest/release/versions.html']",
  );
  versionListLink.textContent = "Preview versions";
  versionListLink.href =
    "https://rocm.docs.amd.com/en/docs-7.9.0/about/versions.html";
});
