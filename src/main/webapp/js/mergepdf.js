let pdfsToMerge = [];

// function uploadPDFs() {
//     const input = document.getElementById('pdfInput');
//     const fileList = input.files;
//     const pdfList = document.getElementById('pdfList');
//     pdfList.innerHTML = ''; // Clear existing list
//     for (let i = 0; i < fileList.length; i++) {
//         const li = document.createElement('li');
//         li.textContent = fileList[i].name;
//         li.className = 'list-group-item';
//         pdfList.appendChild(li);
//         pdfsToMerge.push(fileList[i]);
//     }
//     // Optionally, implement reordering logic here
// }

// function uploadPDFs() {
//     const input = document.getElementById('pdfInput');
//     const fileList = input.files;
//     const pdfList = document.getElementById('pdfList');
//     pdfList.innerHTML = ''; // Clear existing list
//     pdfsToMerge = []; // Reset the array
//
//     for (let i = 0; i < fileList.length; i++) {
//         pdfsToMerge.push(fileList[i]); // Add file to array for later processing
//         const li = document.createElement('li');
//         li.textContent = fileList[i].name;
//         li.className = 'list-group-item';
//         li.setAttribute('data-id', i); // Set a data attribute for identifying the item
//         pdfList.appendChild(li);
//     }
//
//     // Make the list sortable
//     new Sortable(pdfList, {
//         animation: 150,
//         onEnd: function (/**Event*/evt) {
//             // Update `pdfsToMerge` array based on new order
//             const item = pdfsToMerge.splice(evt.oldIndex, 1)[0];
//             pdfsToMerge.splice(evt.newIndex, 0, item);
//         },
//     });
// }

function uploadPDFs() {
    const input = document.getElementById('pdfInput');
    if (input.files.length > 0) {
        const mergeBtn = document.getElementById('mergeBtn');
        mergeBtn.style.display = 'block'; // Show the Merge PDFs button
        const fileList = input.files;
        const pdfList = document.getElementById('pdfList');
        pdfList.innerHTML = ''; // Clear existing list
        pdfsToMerge = []; // Reset the array

        for (let i = 0; i < fileList.length; i++) {
            pdfsToMerge.push({file: fileList[i], order: i}); // Add file with order
            const li = document.createElement('li');
            li.className = 'list-group-item d-flex justify-content-between align-items-center';
            li.innerHTML = `
            <span>${fileList[i].name}</span>
            <div>
                <button class="btn btn-secondary btn-sm mr-2" onclick="moveUp(${i})">Up</button>
                <button class="btn btn-secondary btn-sm" onclick="moveDown(${i})">Down</button>
            </div>`;
            pdfList.appendChild(li);
        }
    }
}

function moveUp(index) {
    if (index === 0) return; // Can't move up the first item

    console.log("Before merging moveUp, pdfsToMerge:", pdfsToMerge.map(item => ({name: item.file.name, order: item.order})));
    // Swap items
    [pdfsToMerge[index], pdfsToMerge[index - 1]] = [pdfsToMerge[index - 1], pdfsToMerge[index]];
    // Update order properties to reflect their new positions
    pdfsToMerge[index].order = index;
    pdfsToMerge[index - 1].order = index - 1;

    console.log("After merging moveUp, pdfsToMerge:", pdfsToMerge.map(item => ({name: item.file.name, order: item.order})));
    refreshPDFList(); // Refresh the list display
}

function moveDown(index) {
    if (index === pdfsToMerge.length - 1) return; // Can't move down the last item

    console.log("Before merging moveDown, pdfsToMerge:", pdfsToMerge.map(item => ({name: item.file.name, order: item.order})));
    // Swap items
    [pdfsToMerge[index], pdfsToMerge[index + 1]] = [pdfsToMerge[index + 1], pdfsToMerge[index]];
    // Update order properties to reflect their new positions
    pdfsToMerge[index].order = index;
    pdfsToMerge[index + 1].order = index + 1;

    console.log("After merging moveDown, pdfsToMerge:", pdfsToMerge.map(item => ({name: item.file.name, order: item.order})));
    refreshPDFList(); // Refresh the list display
}

function refreshPDFList() {
    const pdfList = document.getElementById('pdfList');
    pdfList.innerHTML = ''; // Clear the list
    pdfsToMerge.forEach((item, index) => {
        const li = document.createElement('li');
        li.className = 'list-group-item d-flex justify-content-between align-items-center';
        li.innerHTML = `
            <span>${item.file.name}</span>
            <div>
                <button class="btn btn-secondary btn-sm mr-2" onclick="moveUp(${index})">Up</button>
                <button class="btn btn-secondary btn-sm" onclick="moveDown(${index})">Down</button>
            </div>`;
        pdfList.appendChild(li);
    });
}

async function mergePDFs() {
    const { PDFDocument } = PDFLib;
    const mergedPdf = await PDFDocument.create();

    // Sort the array of PDFs to merge by their 'order' property
    const sortedPDFs = pdfsToMerge.sort((a, b) => a.order - b.order);

    console.log("mergePDFs:", sortedPDFs.map(item => ({name: item.file.name, order: item.order})));

    for (const pdfItem of sortedPDFs) {
        // Use FileReader to read the file as ArrayBuffer
        const fileReader = new FileReader();
        fileReader.readAsArrayBuffer(pdfItem.file);
        await new Promise((resolve, reject) => {
            fileReader.onload = async (e) => {
                try {
                    const arrayBuffer = e.target.result;
                    const pdfDoc = await PDFDocument.load(arrayBuffer);
                    const copiedPages = await mergedPdf.copyPages(pdfDoc, pdfDoc.getPageIndices());
                    copiedPages.forEach(page => mergedPdf.addPage(page));
                    resolve(); // Resolve the promise after processing each PDF
                } catch (error) {
                    console.error("Error processing PDF: ", error);
                    reject(error); // Reject the promise if there's an error
                }
            };
        });
    }

    // Once all PDFs are processed and added, save the merged PDF and initiate download
    const mergedPdfBytes = await mergedPdf.save();
    // Hide the Merge PDFs button
    document.getElementById('mergeBtn').style.display = 'none';

    // Dynamically create and show a Download button
    // Create the Download button
    const downloadBtn = document.createElement('button');
    downloadBtn.id = 'downloadPdfBtn'; // Assign an ID to the button for potential removal
    downloadBtn.className = 'btn btn-primary mt-3';
    downloadBtn.textContent = 'Download Merged PDF';
    downloadBtn.onclick = () => downloadMergedPDF(mergedPdfBytes, "merged.pdf");

    // Find the dedicated div and append the button to it
    document.getElementById('downloadButtonContainer').appendChild(downloadBtn);
    //downloadMergedPDF(mergedPdfBytes, "merged.pdf");
}

function downloadMergedPDF(pdfBytes, fileName) {
    const blob = new Blob([pdfBytes], { type: "application/pdf" });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = fileName;
    // document.body.appendChild(link); // Append link to body to make it work in Firefox
    link.click();
    // document.body.removeChild(link); // Clean up
}


function downloadMergedPDF(pdfBytes, fileName) {
    const blob = new Blob([pdfBytes], { type: "application/pdf" });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = fileName;
    link.click();
}
