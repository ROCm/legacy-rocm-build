document.addEventListener("DOMContentLoaded", () => {
  const nextLink = document.querySelector("footer.prev-next-footer a.right-next");
  const nextTitle = nextLink.querySelector(".prev-next-title");
  console.log(nextLink);
  nextTitle.textContent = "Build the ROCm Core SDK from source";
  nextLink.href = "./build-from-source.html";
});
