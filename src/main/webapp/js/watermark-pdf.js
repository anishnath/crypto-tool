// async function addWatermark() {
//     const input = document.getElementById('pdfInput');
//
//     if (!input.files[0]) {
//         alert('Please upload a PDF file.');
//         return;
//     }
//
//     const fileReader = new FileReader();
//     fileReader.readAsArrayBuffer(input.files[0]);
//     fileReader.onload = async (e) => {
//         const arrayBuffer = e.target.result;
//         const pdfDoc = await PDFLib.PDFDocument.load(arrayBuffer);
//
//         // Define the watermark
//         const watermarkText = "CONFIDENTIAL";
//
//         // Load a standard font
//         const helveticaFont = await pdfDoc.embedFont(PDFLib.StandardFonts.Helvetica);
//
//         const pages = pdfDoc.getPages();
//         pages.forEach(page => {
//             const { width, height } = page.getSize();
//             const fontSize = 50;
//             page.drawText(watermarkText, {
//                 x: width / 2 - (helveticaFont.widthOfTextAtSize(watermarkText, fontSize) / 2),
//                 y: height / 2,
//                 size: fontSize,
//                 font: helveticaFont,
//                 color: PDFLib.rgb(0.75, 0.75, 0.75),
//                 opacity: 0.5,
//                 rotate: PDFLib.degrees(-45),
//             });
//         });
//
//         const pdfBytes = await pdfDoc.save();
//         downloadPDF(pdfBytes, 'watermarked.pdf');
//     };
// }

async function addWatermark() {
    const input = document.getElementById('pdfInput');
    const watermarkText = document.getElementById('watermarkText').value || 'CONFIDENTIAL';
    const watermarkColorInput = document.getElementById('watermarkColor').value;
    const watermarkPosition = document.getElementById('watermarkPosition').value;
    const watermarkType = document.getElementById('watermarkType').value;

    if (watermarkType === 'qr') {
        const qrText = document.getElementById('watermarkText').value || 'CONFIDENTIAL';
        try {
            const qrCanvas = await generateQRCode(qrText);
            await addQRCodeWatermark(qrCanvas);
        } catch (error) {
            console.error('Error generating QR code:', error);
        }
    } else {
        // Call addTextWatermark or equivalent function for adding a text watermark
        await addTextWatermark();
    }
}

async function addTextWatermark() {
    const input = document.getElementById('pdfInput');
    const watermarkText = document.getElementById('watermarkText').value || 'CONFIDENTIAL';
    const watermarkColorInput = document.getElementById('watermarkColor').value;
    const fontSize = parseInt(document.getElementById('fontSizeSlider').value, 10);
    const watermarkPosition = document.getElementById('watermarkPosition').value;

    // Convert hex color to RGB for PDF-Lib
    const watermarkColor = hexToRgb(watermarkColorInput);

    if (!input.files[0]) {
        alert('Please upload a PDF file.');
        return;
    }

    const fileReader = new FileReader();
    fileReader.readAsArrayBuffer(input.files[0]);
    fileReader.onload = async (e) => {
        const arrayBuffer = e.target.result;
        const pdfDoc = await PDFLib.PDFDocument.load(arrayBuffer);

        const helveticaFont = await pdfDoc.embedFont(PDFLib.StandardFonts.Helvetica);
        const pages = pdfDoc.getPages();

        pages.forEach(page => {
            const { width, height } = page.getSize();
            let x, y;
            // Calculate position based on selection
            switch (watermarkPosition) {
                case 'top-left':
                    x = 50;
                    y = height - 50 - fontSize;
                    break;
                case 'top-right':
                    x = width - 50 - helveticaFont.widthOfTextAtSize(watermarkText, fontSize);
                    y = height - 50 - fontSize;
                    break;
                case 'bottom-left':
                    x = 50;
                    y = 50;
                    break;
                case 'bottom-right':
                    x = width - 50 - helveticaFont.widthOfTextAtSize(watermarkText, fontSize);
                    y = 50;
                    break;
                case 'center':
                default:
                    x = width / 2 - (helveticaFont.widthOfTextAtSize(watermarkText, fontSize) / 2);
                    y = height / 2;
                    break;
            }
            page.drawText(watermarkText, {
                x: x,
                y: y,
                size: fontSize,
                font: helveticaFont,
                color: PDFLib.rgb(watermarkColor.r / 255, watermarkColor.g / 255, watermarkColor.b / 255),
                opacity: 0.5,
                rotate: PDFLib.degrees(-45),
            });
        });

        const pdfBytes = await pdfDoc.save();
        downloadPDF(pdfBytes, 'Text_Watermarked.pdf');
    };
}


async function generateQRCode(text) {
    // Create a canvas element to render the QR code
    let canvas = document.createElement('canvas');

    // Use the QRCode library to generate the QR code
    // This function returns a Promise that resolves when the QR code has been drawn to the canvas
    return new Promise((resolve, reject) => {
        QRCode.toCanvas(canvas, text, { width: 200 }, function (error) {
            if (error) {
                reject(error);
            } else {
                resolve(canvas);
            }
        });
    });
}


function hexToRgb(hex) {
    let r = 0, g = 0, b = 0;
    // 3 digits
    if (hex.length == 4) {
        r = parseInt(hex[1] + hex[1], 16);
        g = parseInt(hex[2] + hex[2], 16);
        b = parseInt(hex[3] + hex[3], 16);
    }
    // 6 digits
    else if (hex.length == 7) {
        r = parseInt(hex[1] + hex[2], 16);
        g = parseInt(hex[3] + hex[4], 16);
        b = parseInt(hex[5] + hex[6], 16);
    }
    return { r, g, b };
}

async function addQRCodeWatermark(qrCanvas) {
    const input = document.getElementById('pdfInput');
    if (!input.files[0]) {
        alert('Please upload a PDF file.');
        return;
    }

    const fileReader = new FileReader();
    fileReader.readAsArrayBuffer(input.files[0]);
    fileReader.onload = async (e) => {
        const arrayBuffer = e.target.result;
        const pdfDoc = await PDFLib.PDFDocument.load(arrayBuffer);

        // Convert the QR code canvas to a Blob, then to an ArrayBuffer, and embed it into the PDF
        qrCanvas.toBlob(async function(blob) {
            const reader = new FileReader();
            reader.readAsArrayBuffer(blob);
            reader.onloadend = async () => {
                const qrArrayBuffer = reader.result;
                const qrImageEmbed = await pdfDoc.embedPng(new Uint8Array(qrArrayBuffer));

                const pages = pdfDoc.getPages();
                pages.forEach(page => {
                    const { width, height } = page.getSize();
                    page.drawImage(qrImageEmbed, {
                        x: width / 2 - qrImageEmbed.width / 2,
                        y: height / 2 - qrImageEmbed.height / 2,
                        width: qrImageEmbed.width / 2, // Adjust size as needed
                        height: qrImageEmbed.height / 2, // Adjust size as needed
                        opacity: 0.5
                    });
                });

                const pdfBytes = await pdfDoc.save();
                downloadPDF(pdfBytes, 'QR_Watermarked.pdf');
            };
        });
    };
}


function downloadPDF(pdfBytes, fileName) {
    // const blob = new Blob([pdfBytes], { type: 'application/pdf' });
    // const link = document.createElement('a');
    // link.href = URL.createObjectURL(blob);
    // link.download = fileName;
    // document.body.appendChild(link); // Append link to body to make it work in Firefox
    // link.click();
    // document.body.removeChild(link); // Clean up

    const pdfBlob = new Blob([pdfBytes], { type: 'application/pdf' });
    const downloadUrl = URL.createObjectURL(pdfBlob);
    const downloadBtn = document.getElementById('downloadBtn');
    downloadBtn.style.display = 'block'; // Make the download button visible
    downloadBtn.onclick = function() {
        const link = document.createElement('a');
        link.href = downloadUrl;
        link.download = 'Watermarked_PDF.pdf'; // Set the filename for the download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        resetForm();
    };
}


function resetForm() {
    // Reset the file input
    document.getElementById('pdfInput').value = '';

    // Reset the text input to default
    document.getElementById('watermarkText').value = 'MADE BY 8GWIFI.ORG';

    // Reset the color picker to red
    document.getElementById('watermarkColor').value = '#FF0000';

    // Reset the font size slider and display
    document.getElementById('fontSizeSlider').value = '50';
    document.getElementById('fontSizeValue').textContent = '50';

    // Reset the watermark position selector to the first option
    document.getElementById('watermarkPosition').selectedIndex = 0;

    // Reset the watermark type selector to the first option
    document.getElementById('watermarkType').selectedIndex = 0;

    // Hide the download button
    document.getElementById('downloadBtn').style.display = 'none';
    const downloadMessage = document.getElementById('downloadMessage');
    downloadMessage.style.display = 'block';

    // Optionally, hide the message after a few seconds
    setTimeout(() => {
        downloadMessage.style.display = 'none';
    }, 10000); // Adjust time as needed
}
