module LDST_KFMMC_SPI_ROM (clock, address, data_out);
    input clock;
    input [9:0] address;
    output reg [12:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            10'h0000: data_out = 12'h203;
            10'h0001: data_out = 12'h182;
            10'h0002: data_out = 12'h200;
            10'h0003: data_out = 12'h183;
            10'h0004: data_out = 12'h20a;
            10'h0005: data_out = 12'h104;
            10'h0006: data_out = 12'h2ff;
            10'h0007: data_out = 12'h180;
            10'h0008: data_out = 12'h202;
            10'h0009: data_out = 12'h434;
            10'h000a: data_out = 12'h004;
            10'h000b: data_out = 12'h100;
            10'h000c: data_out = 12'h201;
            10'h000d: data_out = 12'h101;
            10'h000e: data_out = 12'h282;
            10'h000f: data_out = 12'h103;
            10'h0010: data_out = 12'h003;
            10'h0011: data_out = 12'h104;
            10'h0012: data_out = 12'h200;
            10'h0013: data_out = 12'h916;
            10'h0014: data_out = 12'h200;
            10'h0015: data_out = 12'h806;
            10'h0016: data_out = 12'h2fd;
            10'h0017: data_out = 12'h100;
            10'h0018: data_out = 12'h202;
            10'h0019: data_out = 12'h42d;
            10'h001a: data_out = 12'h240;
            10'h001b: data_out = 12'h180;
            10'h001c: data_out = 12'h202;
            10'h001d: data_out = 12'h434;
            10'h001e: data_out = 12'h202;
            10'h001f: data_out = 12'h451;
            10'h0020: data_out = 12'h295;
            10'h0021: data_out = 12'h180;
            10'h0022: data_out = 12'h202;
            10'h0023: data_out = 12'h434;
            10'h0024: data_out = 12'h20a;
            10'h0025: data_out = 12'h104;
            10'h0026: data_out = 12'h202;
            10'h0027: data_out = 12'h462;
            10'h0028: data_out = 12'h005;
            10'h0029: data_out = 12'h100;
            10'h002a: data_out = 12'h201;
            10'h002b: data_out = 12'h101;
            10'h002c: data_out = 12'h240;
            10'h002d: data_out = 12'h103;
            10'h002e: data_out = 12'h003;
            10'h002f: data_out = 12'h200;
            10'h0030: data_out = 12'h933;
            10'h0031: data_out = 12'h200;
            10'h0032: data_out = 12'h800;
            10'h0033: data_out = 12'h082;
            10'h0034: data_out = 12'h100;
            10'h0035: data_out = 12'h204;
            10'h0036: data_out = 12'h101;
            10'h0037: data_out = 12'h200;
            10'h0038: data_out = 12'h103;
            10'h0039: data_out = 12'h003;
            10'h003a: data_out = 12'h200;
            10'h003b: data_out = 12'h961;
            10'h003c: data_out = 12'h2ff;
            10'h003d: data_out = 12'h106;
            10'h003e: data_out = 12'h241;
            10'h003f: data_out = 12'h180;
            10'h0040: data_out = 12'h202;
            10'h0041: data_out = 12'h434;
            10'h0042: data_out = 12'h202;
            10'h0043: data_out = 12'h440;
            10'h0044: data_out = 12'h2f9;
            10'h0045: data_out = 12'h180;
            10'h0046: data_out = 12'h202;
            10'h0047: data_out = 12'h434;
            10'h0048: data_out = 12'h20a;
            10'h0049: data_out = 12'h104;
            10'h004a: data_out = 12'h202;
            10'h004b: data_out = 12'h462;
            10'h004c: data_out = 12'h005;
            10'h004d: data_out = 12'h100;
            10'h004e: data_out = 12'h200;
            10'h004f: data_out = 12'h101;
            10'h0050: data_out = 12'h240;
            10'h0051: data_out = 12'h103;
            10'h0052: data_out = 12'h003;
            10'h0053: data_out = 12'h200;
            10'h0054: data_out = 12'h9e4;
            10'h0055: data_out = 12'h006;
            10'h0056: data_out = 12'h100;
            10'h0057: data_out = 12'h201;
            10'h0058: data_out = 12'h101;
            10'h0059: data_out = 12'h282;
            10'h005a: data_out = 12'h103;
            10'h005b: data_out = 12'h003;
            10'h005c: data_out = 12'h106;
            10'h005d: data_out = 12'h200;
            10'h005e: data_out = 12'h900;
            10'h005f: data_out = 12'h200;
            10'h0060: data_out = 12'h83e;
            10'h0061: data_out = 12'h202;
            10'h0062: data_out = 12'h44c;
            10'h0063: data_out = 12'h248;
            10'h0064: data_out = 12'h180;
            10'h0065: data_out = 12'h202;
            10'h0066: data_out = 12'h434;
            10'h0067: data_out = 12'h200;
            10'h0068: data_out = 12'h180;
            10'h0069: data_out = 12'h202;
            10'h006a: data_out = 12'h434;
            10'h006b: data_out = 12'h200;
            10'h006c: data_out = 12'h180;
            10'h006d: data_out = 12'h202;
            10'h006e: data_out = 12'h434;
            10'h006f: data_out = 12'h201;
            10'h0070: data_out = 12'h180;
            10'h0071: data_out = 12'h202;
            10'h0072: data_out = 12'h434;
            10'h0073: data_out = 12'h2aa;
            10'h0074: data_out = 12'h180;
            10'h0075: data_out = 12'h202;
            10'h0076: data_out = 12'h434;
            10'h0077: data_out = 12'h287;
            10'h0078: data_out = 12'h180;
            10'h0079: data_out = 12'h202;
            10'h007a: data_out = 12'h434;
            10'h007b: data_out = 12'h20a;
            10'h007c: data_out = 12'h104;
            10'h007d: data_out = 12'h202;
            10'h007e: data_out = 12'h462;
            10'h007f: data_out = 12'h005;
            10'h0080: data_out = 12'h100;
            10'h0081: data_out = 12'h201;
            10'h0082: data_out = 12'h101;
            10'h0083: data_out = 12'h240;
            10'h0084: data_out = 12'h103;
            10'h0085: data_out = 12'h003;
            10'h0086: data_out = 12'h200;
            10'h0087: data_out = 12'h98e;
            10'h0088: data_out = 12'h204;
            10'h0089: data_out = 12'h100;
            10'h008a: data_out = 12'h202;
            10'h008b: data_out = 12'h426;
            10'h008c: data_out = 12'h200;
            10'h008d: data_out = 12'h804;
            10'h008e: data_out = 12'h202;
            10'h008f: data_out = 12'h444;
            10'h0090: data_out = 12'h080;
            10'h0091: data_out = 12'h100;
            10'h0092: data_out = 12'h201;
            10'h0093: data_out = 12'h101;
            10'h0094: data_out = 12'h200;
            10'h0095: data_out = 12'h103;
            10'h0096: data_out = 12'h003;
            10'h0097: data_out = 12'h200;
            10'h0098: data_out = 12'h900;
            10'h0099: data_out = 12'h2ff;
            10'h009a: data_out = 12'h180;
            10'h009b: data_out = 12'h202;
            10'h009c: data_out = 12'h434;
            10'h009d: data_out = 12'h080;
            10'h009e: data_out = 12'h100;
            10'h009f: data_out = 12'h2aa;
            10'h00a0: data_out = 12'h101;
            10'h00a1: data_out = 12'h282;
            10'h00a2: data_out = 12'h103;
            10'h00a3: data_out = 12'h003;
            10'h00a4: data_out = 12'h200;
            10'h00a5: data_out = 12'h9a8;
            10'h00a6: data_out = 12'h200;
            10'h00a7: data_out = 12'h800;
            10'h00a8: data_out = 12'h202;
            10'h00a9: data_out = 12'h44c;
            10'h00aa: data_out = 12'h277;
            10'h00ab: data_out = 12'h180;
            10'h00ac: data_out = 12'h202;
            10'h00ad: data_out = 12'h434;
            10'h00ae: data_out = 12'h202;
            10'h00af: data_out = 12'h451;
            10'h00b0: data_out = 12'h20a;
            10'h00b1: data_out = 12'h104;
            10'h00b2: data_out = 12'h202;
            10'h00b3: data_out = 12'h462;
            10'h00b4: data_out = 12'h005;
            10'h00b5: data_out = 12'h100;
            10'h00b6: data_out = 12'h201;
            10'h00b7: data_out = 12'h101;
            10'h00b8: data_out = 12'h240;
            10'h00b9: data_out = 12'h103;
            10'h00ba: data_out = 12'h003;
            10'h00bb: data_out = 12'h200;
            10'h00bc: data_out = 12'h9bf;
            10'h00bd: data_out = 12'h200;
            10'h00be: data_out = 12'h800;
            10'h00bf: data_out = 12'h202;
            10'h00c0: data_out = 12'h44c;
            10'h00c1: data_out = 12'h269;
            10'h00c2: data_out = 12'h180;
            10'h00c3: data_out = 12'h202;
            10'h00c4: data_out = 12'h434;
            10'h00c5: data_out = 12'h240;
            10'h00c6: data_out = 12'h180;
            10'h00c7: data_out = 12'h202;
            10'h00c8: data_out = 12'h434;
            10'h00c9: data_out = 12'h2ff;
            10'h00ca: data_out = 12'h180;
            10'h00cb: data_out = 12'h202;
            10'h00cc: data_out = 12'h434;
            10'h00cd: data_out = 12'h280;
            10'h00ce: data_out = 12'h180;
            10'h00cf: data_out = 12'h202;
            10'h00d0: data_out = 12'h434;
            10'h00d1: data_out = 12'h200;
            10'h00d2: data_out = 12'h180;
            10'h00d3: data_out = 12'h202;
            10'h00d4: data_out = 12'h434;
            10'h00d5: data_out = 12'h20a;
            10'h00d6: data_out = 12'h104;
            10'h00d7: data_out = 12'h202;
            10'h00d8: data_out = 12'h462;
            10'h00d9: data_out = 12'h005;
            10'h00da: data_out = 12'h100;
            10'h00db: data_out = 12'h200;
            10'h00dc: data_out = 12'h101;
            10'h00dd: data_out = 12'h240;
            10'h00de: data_out = 12'h103;
            10'h00df: data_out = 12'h003;
            10'h00e0: data_out = 12'h200;
            10'h00e1: data_out = 12'h9e4;
            10'h00e2: data_out = 12'h200;
            10'h00e3: data_out = 12'h8a8;
            10'h00e4: data_out = 12'h202;
            10'h00e5: data_out = 12'h44c;
            10'h00e6: data_out = 12'h249;
            10'h00e7: data_out = 12'h180;
            10'h00e8: data_out = 12'h202;
            10'h00e9: data_out = 12'h434;
            10'h00ea: data_out = 12'h202;
            10'h00eb: data_out = 12'h451;
            10'h00ec: data_out = 12'h20a;
            10'h00ed: data_out = 12'h104;
            10'h00ee: data_out = 12'h202;
            10'h00ef: data_out = 12'h462;
            10'h00f0: data_out = 12'h005;
            10'h00f1: data_out = 12'h100;
            10'h00f2: data_out = 12'h200;
            10'h00f3: data_out = 12'h101;
            10'h00f4: data_out = 12'h240;
            10'h00f5: data_out = 12'h103;
            10'h00f6: data_out = 12'h003;
            10'h00f7: data_out = 12'h200;
            10'h00f8: data_out = 12'h9fb;
            10'h00f9: data_out = 12'h200;
            10'h00fa: data_out = 12'h800;
            10'h00fb: data_out = 12'h20a;
            10'h00fc: data_out = 12'h104;
            10'h00fd: data_out = 12'h2fe;
            10'h00fe: data_out = 12'h105;
            10'h00ff: data_out = 12'h202;
            10'h0100: data_out = 12'h47d;
            10'h0101: data_out = 12'h006;
            10'h0102: data_out = 12'h100;
            10'h0103: data_out = 12'h2fe;
            10'h0104: data_out = 12'h101;
            10'h0105: data_out = 12'h240;
            10'h0106: data_out = 12'h103;
            10'h0107: data_out = 12'h003;
            10'h0108: data_out = 12'h201;
            10'h0109: data_out = 12'h90c;
            10'h010a: data_out = 12'h200;
            10'h010b: data_out = 12'h800;
            10'h010c: data_out = 12'h210;
            10'h010d: data_out = 12'h104;
            10'h010e: data_out = 12'h2ff;
            10'h010f: data_out = 12'h180;
            10'h0110: data_out = 12'h202;
            10'h0111: data_out = 12'h434;
            10'h0112: data_out = 12'h080;
            10'h0113: data_out = 12'h185;
            10'h0114: data_out = 12'h004;
            10'h0115: data_out = 12'h100;
            10'h0116: data_out = 12'h201;
            10'h0117: data_out = 12'h101;
            10'h0118: data_out = 12'h282;
            10'h0119: data_out = 12'h103;
            10'h011a: data_out = 12'h003;
            10'h011b: data_out = 12'h104;
            10'h011c: data_out = 12'h201;
            10'h011d: data_out = 12'h920;
            10'h011e: data_out = 12'h201;
            10'h011f: data_out = 12'h80e;
            10'h0120: data_out = 12'h202;
            10'h0121: data_out = 12'h44c;
            10'h0122: data_out = 12'h27a;
            10'h0123: data_out = 12'h180;
            10'h0124: data_out = 12'h202;
            10'h0125: data_out = 12'h434;
            10'h0126: data_out = 12'h202;
            10'h0127: data_out = 12'h451;
            10'h0128: data_out = 12'h20a;
            10'h0129: data_out = 12'h104;
            10'h012a: data_out = 12'h202;
            10'h012b: data_out = 12'h462;
            10'h012c: data_out = 12'h005;
            10'h012d: data_out = 12'h100;
            10'h012e: data_out = 12'h200;
            10'h012f: data_out = 12'h101;
            10'h0130: data_out = 12'h240;
            10'h0131: data_out = 12'h103;
            10'h0132: data_out = 12'h003;
            10'h0133: data_out = 12'h201;
            10'h0134: data_out = 12'h937;
            10'h0135: data_out = 12'h200;
            10'h0136: data_out = 12'h800;
            10'h0137: data_out = 12'h2bf;
            10'h0138: data_out = 12'h100;
            10'h0139: data_out = 12'h202;
            10'h013a: data_out = 12'h42d;
            10'h013b: data_out = 12'h2ff;
            10'h013c: data_out = 12'h180;
            10'h013d: data_out = 12'h202;
            10'h013e: data_out = 12'h434;
            10'h013f: data_out = 12'h080;
            10'h0140: data_out = 12'h100;
            10'h0141: data_out = 12'h240;
            10'h0142: data_out = 12'h101;
            10'h0143: data_out = 12'h200;
            10'h0144: data_out = 12'h103;
            10'h0145: data_out = 12'h003;
            10'h0146: data_out = 12'h100;
            10'h0147: data_out = 12'h202;
            10'h0148: data_out = 12'h426;
            10'h0149: data_out = 12'h202;
            10'h014a: data_out = 12'h444;
            10'h014b: data_out = 12'h2ff;
            10'h014c: data_out = 12'h180;
            10'h014d: data_out = 12'h202;
            10'h014e: data_out = 12'h434;
            10'h014f: data_out = 12'h080;
            10'h0150: data_out = 12'h100;
            10'h0151: data_out = 12'h2ff;
            10'h0152: data_out = 12'h101;
            10'h0153: data_out = 12'h240;
            10'h0154: data_out = 12'h103;
            10'h0155: data_out = 12'h003;
            10'h0156: data_out = 12'h201;
            10'h0157: data_out = 12'h95a;
            10'h0158: data_out = 12'h201;
            10'h0159: data_out = 12'h84b;
            10'h015a: data_out = 12'h2fe;
            10'h015b: data_out = 12'h100;
            10'h015c: data_out = 12'h202;
            10'h015d: data_out = 12'h42d;
            10'h015e: data_out = 12'h202;
            10'h015f: data_out = 12'h181;
            10'h0160: data_out = 12'h082;
            10'h0161: data_out = 12'h100;
            10'h0162: data_out = 12'h201;
            10'h0163: data_out = 12'h101;
            10'h0164: data_out = 12'h200;
            10'h0165: data_out = 12'h103;
            10'h0166: data_out = 12'h003;
            10'h0167: data_out = 12'h201;
            10'h0168: data_out = 12'h960;
            10'h0169: data_out = 12'h200;
            10'h016a: data_out = 12'h183;
            10'h016b: data_out = 12'h184;
            10'h016c: data_out = 12'h240;
            10'h016d: data_out = 12'h103;
            10'h016e: data_out = 12'h08b;
            10'h016f: data_out = 12'h100;
            10'h0170: data_out = 12'h280;
            10'h0171: data_out = 12'h101;
            10'h0172: data_out = 12'h003;
            10'h0173: data_out = 12'h201;
            10'h0174: data_out = 12'h97c;
            10'h0175: data_out = 12'h281;
            10'h0176: data_out = 12'h101;
            10'h0177: data_out = 12'h003;
            10'h0178: data_out = 12'h201;
            10'h0179: data_out = 12'h9d3;
            10'h017a: data_out = 12'h201;
            10'h017b: data_out = 12'h85a;
            10'h017c: data_out = 12'h2ff;
            10'h017d: data_out = 12'h180;
            10'h017e: data_out = 12'h202;
            10'h017f: data_out = 12'h434;
            10'h0180: data_out = 12'h251;
            10'h0181: data_out = 12'h180;
            10'h0182: data_out = 12'h202;
            10'h0183: data_out = 12'h434;
            10'h0184: data_out = 12'h202;
            10'h0185: data_out = 12'h498;
            10'h0186: data_out = 12'h20a;
            10'h0187: data_out = 12'h104;
            10'h0188: data_out = 12'h202;
            10'h0189: data_out = 12'h462;
            10'h018a: data_out = 12'h005;
            10'h018b: data_out = 12'h100;
            10'h018c: data_out = 12'h200;
            10'h018d: data_out = 12'h101;
            10'h018e: data_out = 12'h240;
            10'h018f: data_out = 12'h103;
            10'h0190: data_out = 12'h003;
            10'h0191: data_out = 12'h201;
            10'h0192: data_out = 12'h995;
            10'h0193: data_out = 12'h201;
            10'h0194: data_out = 12'h8cf;
            10'h0195: data_out = 12'h2ff;
            10'h0196: data_out = 12'h107;
            10'h0197: data_out = 12'h2ff;
            10'h0198: data_out = 12'h104;
            10'h0199: data_out = 12'h2fe;
            10'h019a: data_out = 12'h105;
            10'h019b: data_out = 12'h202;
            10'h019c: data_out = 12'h47d;
            10'h019d: data_out = 12'h006;
            10'h019e: data_out = 12'h100;
            10'h019f: data_out = 12'h2fe;
            10'h01a0: data_out = 12'h101;
            10'h01a1: data_out = 12'h240;
            10'h01a2: data_out = 12'h103;
            10'h01a3: data_out = 12'h003;
            10'h01a4: data_out = 12'h201;
            10'h01a5: data_out = 12'h9b2;
            10'h01a6: data_out = 12'h007;
            10'h01a7: data_out = 12'h100;
            10'h01a8: data_out = 12'h201;
            10'h01a9: data_out = 12'h101;
            10'h01aa: data_out = 12'h282;
            10'h01ab: data_out = 12'h103;
            10'h01ac: data_out = 12'h003;
            10'h01ad: data_out = 12'h107;
            10'h01ae: data_out = 12'h201;
            10'h01af: data_out = 12'h9cf;
            10'h01b0: data_out = 12'h201;
            10'h01b1: data_out = 12'h897;
            10'h01b2: data_out = 12'h2ff;
            10'h01b3: data_out = 12'h104;
            10'h01b4: data_out = 12'h201;
            10'h01b5: data_out = 12'h105;
            10'h01b6: data_out = 12'h2ff;
            10'h01b7: data_out = 12'h180;
            10'h01b8: data_out = 12'h202;
            10'h01b9: data_out = 12'h434;
            10'h01ba: data_out = 12'h201;
            10'h01bb: data_out = 12'h184;
            10'h01bc: data_out = 12'h200;
            10'h01bd: data_out = 12'h103;
            10'h01be: data_out = 12'h201;
            10'h01bf: data_out = 12'h101;
            10'h01c0: data_out = 12'h084;
            10'h01c1: data_out = 12'h100;
            10'h01c2: data_out = 12'h003;
            10'h01c3: data_out = 12'h201;
            10'h01c4: data_out = 12'h9c7;
            10'h01c5: data_out = 12'h201;
            10'h01c6: data_out = 12'h8c0;
            10'h01c7: data_out = 12'h202;
            10'h01c8: data_out = 12'h4d1;
            10'h01c9: data_out = 12'h201;
            10'h01ca: data_out = 12'hab6;
            10'h01cb: data_out = 12'h202;
            10'h01cc: data_out = 12'h184;
            10'h01cd: data_out = 12'h201;
            10'h01ce: data_out = 12'h84b;
            10'h01cf: data_out = 12'h201;
            10'h01d0: data_out = 12'h183;
            10'h01d1: data_out = 12'h201;
            10'h01d2: data_out = 12'h84b;
            10'h01d3: data_out = 12'h2ff;
            10'h01d4: data_out = 12'h180;
            10'h01d5: data_out = 12'h202;
            10'h01d6: data_out = 12'h434;
            10'h01d7: data_out = 12'h258;
            10'h01d8: data_out = 12'h180;
            10'h01d9: data_out = 12'h202;
            10'h01da: data_out = 12'h434;
            10'h01db: data_out = 12'h202;
            10'h01dc: data_out = 12'h498;
            10'h01dd: data_out = 12'h20a;
            10'h01de: data_out = 12'h104;
            10'h01df: data_out = 12'h202;
            10'h01e0: data_out = 12'h462;
            10'h01e1: data_out = 12'h005;
            10'h01e2: data_out = 12'h100;
            10'h01e3: data_out = 12'h200;
            10'h01e4: data_out = 12'h101;
            10'h01e5: data_out = 12'h240;
            10'h01e6: data_out = 12'h103;
            10'h01e7: data_out = 12'h003;
            10'h01e8: data_out = 12'h201;
            10'h01e9: data_out = 12'h9ec;
            10'h01ea: data_out = 12'h202;
            10'h01eb: data_out = 12'h822;
            10'h01ec: data_out = 12'h2ff;
            10'h01ed: data_out = 12'h104;
            10'h01ee: data_out = 12'h201;
            10'h01ef: data_out = 12'h105;
            10'h01f0: data_out = 12'h2ff;
            10'h01f1: data_out = 12'h180;
            10'h01f2: data_out = 12'h202;
            10'h01f3: data_out = 12'h434;
            10'h01f4: data_out = 12'h2fe;
            10'h01f5: data_out = 12'h180;
            10'h01f6: data_out = 12'h202;
            10'h01f7: data_out = 12'h434;
            10'h01f8: data_out = 12'h204;
            10'h01f9: data_out = 12'h184;
            10'h01fa: data_out = 12'h200;
            10'h01fb: data_out = 12'h103;
            10'h01fc: data_out = 12'h204;
            10'h01fd: data_out = 12'h101;
            10'h01fe: data_out = 12'h084;
            10'h01ff: data_out = 12'h100;
            10'h0200: data_out = 12'h003;
            10'h0201: data_out = 12'h202;
            10'h0202: data_out = 12'h905;
            10'h0203: data_out = 12'h201;
            10'h0204: data_out = 12'h8fe;
            10'h0205: data_out = 12'h08a;
            10'h0206: data_out = 12'h180;
            10'h0207: data_out = 12'h202;
            10'h0208: data_out = 12'h434;
            10'h0209: data_out = 12'h202;
            10'h020a: data_out = 12'h4d1;
            10'h020b: data_out = 12'h201;
            10'h020c: data_out = 12'haf8;
            10'h020d: data_out = 12'h202;
            10'h020e: data_out = 12'h444;
            10'h020f: data_out = 12'h080;
            10'h0210: data_out = 12'h100;
            10'h0211: data_out = 12'h21f;
            10'h0212: data_out = 12'h101;
            10'h0213: data_out = 12'h200;
            10'h0214: data_out = 12'h103;
            10'h0215: data_out = 12'h003;
            10'h0216: data_out = 12'h100;
            10'h0217: data_out = 12'h205;
            10'h0218: data_out = 12'h101;
            10'h0219: data_out = 12'h240;
            10'h021a: data_out = 12'h103;
            10'h021b: data_out = 12'h003;
            10'h021c: data_out = 12'h202;
            10'h021d: data_out = 12'h91e;
            10'h021e: data_out = 12'h208;
            10'h021f: data_out = 12'h184;
            10'h0220: data_out = 12'h201;
            10'h0221: data_out = 12'h84b;
            10'h0222: data_out = 12'h202;
            10'h0223: data_out = 12'h183;
            10'h0224: data_out = 12'h201;
            10'h0225: data_out = 12'h84b;
            10'h0226: data_out = 12'h082;
            10'h0227: data_out = 12'h101;
            10'h0228: data_out = 12'h220;
            10'h0229: data_out = 12'h103;
            10'h022a: data_out = 12'h003;
            10'h022b: data_out = 12'h182;
            10'h022c: data_out = 12'h500;
            10'h022d: data_out = 12'h082;
            10'h022e: data_out = 12'h101;
            10'h022f: data_out = 12'h200;
            10'h0230: data_out = 12'h103;
            10'h0231: data_out = 12'h003;
            10'h0232: data_out = 12'h182;
            10'h0233: data_out = 12'h500;
            10'h0234: data_out = 12'h201;
            10'h0235: data_out = 12'h101;
            10'h0236: data_out = 12'h081;
            10'h0237: data_out = 12'h100;
            10'h0238: data_out = 12'h200;
            10'h0239: data_out = 12'h103;
            10'h023a: data_out = 12'h003;
            10'h023b: data_out = 12'h202;
            10'h023c: data_out = 12'h93f;
            10'h023d: data_out = 12'h202;
            10'h023e: data_out = 12'h834;
            10'h023f: data_out = 12'h500;
            10'h0240: data_out = 12'h2ff;
            10'h0241: data_out = 12'h180;
            10'h0242: data_out = 12'h202;
            10'h0243: data_out = 12'h434;
            10'h0244: data_out = 12'h2ff;
            10'h0245: data_out = 12'h180;
            10'h0246: data_out = 12'h202;
            10'h0247: data_out = 12'h434;
            10'h0248: data_out = 12'h2ff;
            10'h0249: data_out = 12'h180;
            10'h024a: data_out = 12'h202;
            10'h024b: data_out = 12'h434;
            10'h024c: data_out = 12'h2ff;
            10'h024d: data_out = 12'h180;
            10'h024e: data_out = 12'h202;
            10'h024f: data_out = 12'h434;
            10'h0250: data_out = 12'h500;
            10'h0251: data_out = 12'h200;
            10'h0252: data_out = 12'h180;
            10'h0253: data_out = 12'h202;
            10'h0254: data_out = 12'h434;
            10'h0255: data_out = 12'h200;
            10'h0256: data_out = 12'h180;
            10'h0257: data_out = 12'h202;
            10'h0258: data_out = 12'h434;
            10'h0259: data_out = 12'h200;
            10'h025a: data_out = 12'h180;
            10'h025b: data_out = 12'h202;
            10'h025c: data_out = 12'h434;
            10'h025d: data_out = 12'h200;
            10'h025e: data_out = 12'h180;
            10'h025f: data_out = 12'h202;
            10'h0260: data_out = 12'h434;
            10'h0261: data_out = 12'h500;
            10'h0262: data_out = 12'h2ff;
            10'h0263: data_out = 12'h180;
            10'h0264: data_out = 12'h202;
            10'h0265: data_out = 12'h434;
            10'h0266: data_out = 12'h080;
            10'h0267: data_out = 12'h105;
            10'h0268: data_out = 12'h100;
            10'h0269: data_out = 12'h280;
            10'h026a: data_out = 12'h101;
            10'h026b: data_out = 12'h200;
            10'h026c: data_out = 12'h103;
            10'h026d: data_out = 12'h003;
            10'h026e: data_out = 12'h202;
            10'h026f: data_out = 12'h97c;
            10'h0270: data_out = 12'h004;
            10'h0271: data_out = 12'h100;
            10'h0272: data_out = 12'h201;
            10'h0273: data_out = 12'h101;
            10'h0274: data_out = 12'h282;
            10'h0275: data_out = 12'h103;
            10'h0276: data_out = 12'h003;
            10'h0277: data_out = 12'h104;
            10'h0278: data_out = 12'h202;
            10'h0279: data_out = 12'h97c;
            10'h027a: data_out = 12'h202;
            10'h027b: data_out = 12'h862;
            10'h027c: data_out = 12'h500;
            10'h027d: data_out = 12'h2ff;
            10'h027e: data_out = 12'h180;
            10'h027f: data_out = 12'h202;
            10'h0280: data_out = 12'h434;
            10'h0281: data_out = 12'h080;
            10'h0282: data_out = 12'h106;
            10'h0283: data_out = 12'h100;
            10'h0284: data_out = 12'h005;
            10'h0285: data_out = 12'h101;
            10'h0286: data_out = 12'h240;
            10'h0287: data_out = 12'h103;
            10'h0288: data_out = 12'h003;
            10'h0289: data_out = 12'h202;
            10'h028a: data_out = 12'h997;
            10'h028b: data_out = 12'h004;
            10'h028c: data_out = 12'h100;
            10'h028d: data_out = 12'h201;
            10'h028e: data_out = 12'h101;
            10'h028f: data_out = 12'h282;
            10'h0290: data_out = 12'h103;
            10'h0291: data_out = 12'h003;
            10'h0292: data_out = 12'h104;
            10'h0293: data_out = 12'h202;
            10'h0294: data_out = 12'h997;
            10'h0295: data_out = 12'h202;
            10'h0296: data_out = 12'h87d;
            10'h0297: data_out = 12'h500;
            10'h0298: data_out = 12'h082;
            10'h0299: data_out = 12'h100;
            10'h029a: data_out = 12'h240;
            10'h029b: data_out = 12'h101;
            10'h029c: data_out = 12'h200;
            10'h029d: data_out = 12'h103;
            10'h029e: data_out = 12'h003;
            10'h029f: data_out = 12'h202;
            10'h02a0: data_out = 12'h9b2;
            10'h02a1: data_out = 12'h089;
            10'h02a2: data_out = 12'h180;
            10'h02a3: data_out = 12'h202;
            10'h02a4: data_out = 12'h434;
            10'h02a5: data_out = 12'h088;
            10'h02a6: data_out = 12'h180;
            10'h02a7: data_out = 12'h202;
            10'h02a8: data_out = 12'h434;
            10'h02a9: data_out = 12'h087;
            10'h02aa: data_out = 12'h180;
            10'h02ab: data_out = 12'h202;
            10'h02ac: data_out = 12'h434;
            10'h02ad: data_out = 12'h086;
            10'h02ae: data_out = 12'h180;
            10'h02af: data_out = 12'h202;
            10'h02b0: data_out = 12'h434;
            10'h02b1: data_out = 12'h500;
            10'h02b2: data_out = 12'h086;
            10'h02b3: data_out = 12'h100;
            10'h02b4: data_out = 12'h2a0;
            10'h02b5: data_out = 12'h103;
            10'h02b6: data_out = 12'h003;
            10'h02b7: data_out = 12'h104;
            10'h02b8: data_out = 12'h087;
            10'h02b9: data_out = 12'h100;
            10'h02ba: data_out = 12'h2a1;
            10'h02bb: data_out = 12'h103;
            10'h02bc: data_out = 12'h003;
            10'h02bd: data_out = 12'h105;
            10'h02be: data_out = 12'h088;
            10'h02bf: data_out = 12'h100;
            10'h02c0: data_out = 12'h003;
            10'h02c1: data_out = 12'h180;
            10'h02c2: data_out = 12'h202;
            10'h02c3: data_out = 12'h434;
            10'h02c4: data_out = 12'h005;
            10'h02c5: data_out = 12'h180;
            10'h02c6: data_out = 12'h202;
            10'h02c7: data_out = 12'h434;
            10'h02c8: data_out = 12'h004;
            10'h02c9: data_out = 12'h180;
            10'h02ca: data_out = 12'h202;
            10'h02cb: data_out = 12'h434;
            10'h02cc: data_out = 12'h200;
            10'h02cd: data_out = 12'h180;
            10'h02ce: data_out = 12'h202;
            10'h02cf: data_out = 12'h434;
            10'h02d0: data_out = 12'h500;
            10'h02d1: data_out = 12'h004;
            10'h02d2: data_out = 12'h100;
            10'h02d3: data_out = 12'h201;
            10'h02d4: data_out = 12'h101;
            10'h02d5: data_out = 12'h282;
            10'h02d6: data_out = 12'h103;
            10'h02d7: data_out = 12'h003;
            10'h02d8: data_out = 12'h104;
            10'h02d9: data_out = 12'h005;
            10'h02da: data_out = 12'h100;
            10'h02db: data_out = 12'h200;
            10'h02dc: data_out = 12'h101;
            10'h02dd: data_out = 12'h283;
            10'h02de: data_out = 12'h103;
            10'h02df: data_out = 12'h003;
            10'h02e0: data_out = 12'h105;
            10'h02e1: data_out = 12'h500;
            default: data_out = 12'hxxx;
        endcase
    end
endmodule