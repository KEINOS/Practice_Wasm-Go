// This script detects 3 most used colors
// Ref: How to Run GoLang (1.15+) Code in a Browser Using WebAssembly
// https://cesarwilliam.medium.com/how-to-run-golang-1-15-code-in-a-browser-using-webassembly-e755bc733e8d

const imgInput = document.getElementById('idImgInput')

imgInput.addEventListener('change', async () => {
    const file = imgInput.files[0]

    showImage(file)
    const colors = await getCommonColors(file)

    console.log("Wasm response:" + colors+ " (colors)");
    showColors(colors)
})

function getCommonColors(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader()

        reader.onload = (event) => {
            const bytes = new Uint8Array(event.target.result)

            resolve(GoFindCommonColors(bytes)); // Request wasm
        }

        imageType = file.type

        reader.readAsArrayBuffer(file)
    })
}

function showColors(colors) {
    const colorsEl = document.querySelectorAll('#colors div')

    colorsEl.forEach((colorEl, index) => {
        colorEl.style.backgroundColor = colors[index]
    })
}

function showImage(file) {
    const sourceImg = document.getElementById('idSourceImg')
    const reader = new FileReader();

    reader.onload = function (event) {
        sourceImg.setAttribute('src', event.target.result)
    }

    reader.readAsDataURL(file)
}
