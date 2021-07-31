// Exported WebAssempty setup releated scripts

const go = new Go();
let mod, inst;

if (!WebAssembly.instantiateStreaming) { // polyfill
    WebAssembly.instantiateStreaming = async (resp, importObject) => {
        const source = await (await resp).arrayBuffer();

        return await WebAssembly.instantiate(source, importObject);
    };
}

WebAssembly.instantiateStreaming(fetch("test.wasm"), go.importObject).then((result) => {
    mod = result.module;
    inst = result.instance;
    runGoWasm();
    enableElements();
}).catch((err) => {
    console.error(err);
});

async function runGoWasm() {
    console.log("runGoWasm was called")
    //console.clear();
    await go.run(inst);

    inst = await WebAssembly.instantiate(mod, go.importObject); // reset instance
}
