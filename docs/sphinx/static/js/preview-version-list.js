function ready(proc) {
	if (document.readyState !== "loading") {
		proc();
		return;
	}
	document.addEventListener("DOMContentLoaded", proc);
}

ready(() => {
	const versionListLink = document.querySelector(
		"a.header-all-versions[href='https://rocm.docs.amd.com/en/latest/release/versions.html']",
	);
	versionListLink.textContent = "Preview versions"
	versionListLink.href = "https://rocm.docs.amd.com/en/docs-7.0-alpha-2/preview/versions.html"
});
