import React, { useState, useEffect } from "react";
import { supabase } from "../../supabaseClient";
import getCroppedImg from "../Dropzone/cropImageUtil";
import {
  getLocationOptions,
  allowsCustomInput,
} from "../../config/siteLocations";

const SITE_OPTIONS = [
  "Head Office",
  "Balikpapan",
  "ADRO",
  "AMMP",
  "BSIB",
  "GAMR",
  "HRSB",
  "HRSE",
  "PABB",
  "PBRB",
  "PKJA",
  "PPAB",
  "PSMM",
  "REBH",
  "RMTU",
  "PMTU",
];

function getToday() {
  const today = new Date();
  return today.toISOString().slice(0, 10);
}

const Take5FormMobile = ({ user, onRedirectHazard }) => {
  const [site, setSite] = useState(user.site || "");
  const [detailLokasi, setDetailLokasi] = useState("");
  const [locationOptions, setLocationOptions] = useState([]);
  const [showCustomInput, setShowCustomInput] = useState(false);
  const [potensiBahaya, setPotensiBahaya] = useState("");
  const [q1, setQ1] = useState(null);
  const [q2, setQ2] = useState(null);
  const [q3, setQ3] = useState(null);
  const [q4, setQ4] = useState(null);
  const [aman, setAman] = useState("");
  const [buktiPerbaikan, setBuktiPerbaikan] = useState(null);
  const [buktiPreview, setBuktiPreview] = useState(null);
  const [deskripsiPerbaikan, setDeskripsiPerbaikan] = useState("");
  const [deskripsiKondisi, setDeskripsiKondisi] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [showCropper, setShowCropper] = useState(false);
  const [cropImageSrc, setCropImageSrc] = useState(null);
  const [crop, setCrop] = useState({ x: 0, y: 0, size: 200 });

  // Validasi form
  const isFormValid =
    site &&
    detailLokasi.trim() &&
    potensiBahaya.trim() &&
    q1 !== null &&
    q2 !== null &&
    q3 !== null &&
    q4 !== null &&
    aman &&
    // Validasi untuk perbaikan
    !(
      aman === "perbaikan" &&
      (!buktiPerbaikan || !deskripsiPerbaikan.trim())
    ) &&
    // Validasi untuk stop
    !(aman === "stop" && !deskripsiKondisi.trim());

  // Cek apakah ada jawaban "Tidak" pada pertanyaan
  const hasNegativeAnswer =
    q1 === false || q2 === false || q3 === false || q4 === false;

  // Tombol "Ya" pada kondisi kerja tidak bisa diklik jika ada jawaban "Tidak"
  const isAmanButtonDisabled = hasNegativeAnswer;

  // Otomatis ubah kondisi kerja jika ada jawaban "Tidak" dan kondisi kerja adalah "aman"
  useEffect(() => {
    if (hasNegativeAnswer && aman === "aman") {
      setAman("");
    }
  }, [hasNegativeAnswer, aman]);

  // Update location options when site changes
  useEffect(() => {
    if (site) {
      const options = getLocationOptions(site);
      setLocationOptions(options);
      // Reset detail lokasi when site changes
      setDetailLokasi("");
      setShowCustomInput(false);
    } else {
      setLocationOptions([]);
      setDetailLokasi("");
      setShowCustomInput(false);
    }
  }, [site]);

  // Handle detail lokasi change
  const handleDetailLokasiChange = (e) => {
    const value = e.target.value;
    setDetailLokasi(value);

    // Show custom input if "Lainnya" is selected or if site allows custom input
    if (value === "Lainnya" || (allowsCustomInput(site) && value === "")) {
      setShowCustomInput(true);
      setDetailLokasi("");
    } else {
      setShowCustomInput(false);
    }
  };

  // Debug useEffect untuk monitoring state
  useEffect(() => {
    console.log("State changed - aman:", aman, "isFormValid:", isFormValid);
  }, [aman, isFormValid]);

  // Handler untuk file input
  const handleBuktiChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (ev) => {
        setCropImageSrc(ev.target.result);
        setShowCropper(true);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleCropConfirm = async () => {
    try {
      // Gunakan area crop yang tetap (80% dari gambar)
      const cropArea = {
        x: 10, // 10% dari kiri
        y: 10, // 10% dari atas
        width: 80, // 80% lebar
        height: 80, // 80% tinggi
      };

      const croppedImage = await getCroppedImg(cropImageSrc, cropArea);
      const file = new File([croppedImage], "bukti-perbaikan.jpg", {
        type: "image/jpeg",
      });
      setBuktiPerbaikan(file);
      setBuktiPreview(URL.createObjectURL(croppedImage));
      setShowCropper(false);
      setCropImageSrc(null);
    } catch (e) {
      console.error("Error cropping image:", e);
      // Fallback: gunakan gambar asli tanpa crop
      try {
        const response = await fetch(cropImageSrc);
        const blob = await response.blob();
        const file = new File([blob], "bukti-perbaikan.jpg", {
          type: "image/jpeg",
        });
        setBuktiPerbaikan(file);
        setBuktiPreview(cropImageSrc);
        setShowCropper(false);
        setCropImageSrc(null);
      } catch (fallbackError) {
        console.error("Fallback error:", fallbackError);
        setError("Gagal memproses gambar. Silakan coba lagi.");
        setShowCropper(false);
        setCropImageSrc(null);
      }
    }
  };

  const handleCropCancel = () => {
    setShowCropper(false);
    setCropImageSrc(null);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    console.log("=== DEBUG TAKE 5 MOBILE ===");
    console.log("Form values:", {
      site,
      detailLokasi,
      potensiBahaya,
      q1,
      q2,
      q3,
      q4,
      aman,
      buktiPerbaikan: !!buktiPerbaikan,
      deskripsiPerbaikan,
      deskripsiKondisi,
    });
    console.log("isFormValid:", isFormValid);

    // Validasi manual untuk file bukti
    if (aman === "perbaikan" && !buktiPerbaikan) {
      setLoading(false);
      setError("Silakan upload bukti foto terlebih dahulu.");
      return;
    }

    if (aman === "stop" && !deskripsiKondisi.trim()) {
      setLoading(false);
      setError("Silakan isi deskripsi kondisi terlebih dahulu.");
      return;
    }

    try {
      let buktiUrl = null;
      if (buktiPerbaikan) {
        const fileExt = buktiPerbaikan.name.split(".").pop();
        const fileName = `${Math.random()}.${fileExt}`;
        const filePath = `take5-bukti/${fileName}`;

        const { error: uploadError } = await supabase.storage
          .from("img-test")
          .upload(filePath, buktiPerbaikan);

        if (uploadError) {
          throw new Error("Error uploading bukti");
        }

        const { data } = supabase.storage
          .from("img-test")
          .getPublicUrl(filePath);
        buktiUrl = data.publicUrl;
      }

      // Tentukan status berdasarkan kondisi kerja
      const status = aman === "stop" ? "pending" : "closed";

      // Log data yang akan dikirim untuk debugging
      const take5Data = {
        user_id: user.id,
        tanggal: getToday(),
        site: site,
        detail_lokasi: detailLokasi,
        judul_pekerjaan: "Take 5 Assessment", // Field required di database
        potensi_bahaya: potensiBahaya,
        q1: q1,
        q2: q2,
        q3: q3,
        q4: q4,
        aman: aman,
        status: status,
        pelapor_nama: user.nama || "Unknown", // Nama pelapor dari user login
        nrp: user.nrp || "", // NRP dari user login
      };

      // Tambahkan field opsional hanya jika ada data
      if (deskripsiPerbaikan) {
        take5Data.bukti_perbaikan = deskripsiPerbaikan; // Sesuai nama field di database
      }
      if (buktiUrl) {
        take5Data.bukti_url = buktiUrl; // Tambahkan URL foto jika ada
      }
      if (deskripsiKondisi) {
        take5Data.deskripsi_kondisi = deskripsiKondisi; // Tambahkan deskripsi kondisi
      }

      console.log("Data yang akan dikirim ke Supabase:", take5Data);
      console.log("User data for pelapor_nama:", user);
      console.log("User nama:", user.nama);
      console.log("User nrp:", user.nrp);

      const { data, error } = await supabase.from("take_5").insert(take5Data);

      console.log("Supabase response:", { data, error });

      if (error) {
        console.error("Supabase error details:", error);
        throw error;
      }

      console.log("Take 5 berhasil disimpan!");
      setSuccess(true);

      // Jika kondisi kerja adalah "stop", redirect ke Hazard Report setelah 2 detik
      if (aman === "stop") {
        // Reset form immediately untuk STOP
        setSite(user.site || "");
        setDetailLokasi("");
        setPotensiBahaya("");
        setQ1(null);
        setQ2(null);
        setQ3(null);
        setQ4(null);
        setAman("");
        setBuktiPerbaikan(null);
        setBuktiPreview(null);
        setDeskripsiPerbaikan("");
        setDeskripsiKondisi("");

        setTimeout(() => {
          onRedirectHazard();
        }, 2000);
      } else {
        // Reset form after 3 seconds untuk kondisi lain (aman dan perbaikan)
        setTimeout(() => {
          setSuccess(false);
          setSite(user.site || "");
          setDetailLokasi("");
          setPotensiBahaya("");
          setQ1(null);
          setQ2(null);
          setQ3(null);
          setQ4(null);
          setAman("");
          setBuktiPerbaikan(null);
          setBuktiPreview(null);
          setDeskripsiPerbaikan("");
          setDeskripsiKondisi("");
        }, 3000);
      }
    } catch (err) {
      console.error("Error submitting take 5:", err);
      setError("Gagal menyimpan data Take 5. Silakan coba lagi.");
    } finally {
      setLoading(false);
    }
  };

  // Styles untuk mobile
  const contentAreaStyle = {
    width: "100vw",
    minHeight: "100vh", // ubah dari height fixed ke minHeight
    background: "#f3f4f6",
    display: "flex",
    flexDirection: "column",
    alignItems: "center",
    justifyContent: "flex-start",
    padding: "0px",
    overflow: "auto", // ubah dari hidden ke auto untuk allow scroll
  };

  const mobileCardStyle = {
    background: "#fff",
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    borderBottomLeftRadius: 16, // tambahkan border radius bottom
    borderBottomRightRadius: 16, // tambahkan border radius bottom
    boxShadow: "0 2px 16px #0001",
    paddingTop: 6,
    paddingRight: 6,
    paddingBottom: 80, // tambahkan padding bottom untuk space tombol submit
    paddingLeft: 6,
    width: "100%",
    maxWidth: 425, // fit untuk mobile 425px
    marginBottom: 0,
    minHeight: "100vh", // ubah dari height fixed ke minHeight
    // Hapus height fixed agar card bisa expand
  };

  // Tambahkan style khusus untuk card header mobile agar lebih rapat
  const cardHeaderMobileStyle = {
    background: "#fff",
    borderTopLeftRadius: 16,
    borderTopRightRadius: 16,
    padding: "8px 0 4px 0", // lebih rapat atas bawah
    marginBottom: 0,
    textAlign: "center",
  };

  const headerStyle = {
    textAlign: "center",
    marginBottom: 2, // lebih rapat
    marginTop: 0,
    padding: 0, // lebih rapat
  };

  const formStyle = {
    width: "100%",
    display: "flex",
    flexDirection: "column",
    gap: 2, // lebih rapat
    flex: 1,
    // Hapus overflow hidden agar form bisa scroll
  };

  const fieldMargin = {
    marginBottom: 4, // lebih rapat
    width: "90%", // samakan lebar
    marginLeft: "auto",
    marginRight: "auto",
    marginTop: 8, // jarak dari judul
  };

  const labelStyle = {
    fontWeight: 600,
    color: "#222",
    marginBottom: 2,
    display: "block",
    fontSize: 14, // besarkan lagi
  };

  const inputStyle = {
    width: "100%",
    borderRadius: 8,
    padding: 4, // lebih kecil
    fontSize: 13, // besarkan lagi
    border: "1px solid #d1d5db",
  };

  const questionBtnGroupStyle = {
    display: "flex",
    gap: 4, // lebih rapat
    marginTop: 2,
    justifyContent: "center",
  };

  const radioBtnStyle = (active, color, readOnly) => ({
    flex: 1,
    minWidth: 60, // lebih kecil
    maxWidth: 90, // lebih kecil
    padding: "6px 4px", // lebih kecil
    borderRadius: 8,
    border: "2px solid",
    fontSize: 12, // lebih kecil
    fontWeight: 600,
    cursor: readOnly ? "not-allowed" : "pointer",
    background: active ? color : "#fff",
    color: active ? "#fff" : color,
    borderColor: color,
    opacity: readOnly ? 0.7 : 1,
    transition: "background 0.2s, color 0.2s",
  });

  const amanBtnGroupStyle = {
    display: "flex",
    flexDirection: "column",
    gap: 4, // lebih rapat
    marginTop: 2,
  };

  const amanBtnStyle = (active, color) => ({
    width: "100%",
    padding: "8px 12px", // lebih kecil
    borderRadius: 8,
    border: "2px solid",
    fontSize: 12, // lebih kecil
    fontWeight: 600,
    cursor: "pointer",
    background: active ? color : "#fff",
    color: active ? "#fff" : color,
    borderColor: color,
    transition: "background 0.2s, color 0.2s",
    textAlign: "left",
    lineHeight: 1.3, // lebih rapat
  });

  const submitButtonStyle = {
    background: "#2563eb",
    color: "#fff",
    border: "none",
    borderRadius: 8,
    padding: "8px 0", // lebih kecil
    fontSize: 13, // lebih kecil
    fontWeight: 600,
    cursor: "pointer",
    marginTop: 8,
    width: "60%", // tidak full width
    alignSelf: "center",
  };

  // Crop modal
  if (showCropper) {
    return (
      <div
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: "rgba(0,0,0,0.8)",
          zIndex: 1000,
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          padding: 20,
        }}
      >
        <div
          style={{
            position: "relative",
            width: 280,
            height: 280,
            background: "#fff",
            borderRadius: 12,
            overflow: "hidden",
          }}
        >
          <div
            style={{
              position: "absolute",
              top: 10,
              left: 10,
              right: 10,
              background: "rgba(0,0,0,0.7)",
              color: "#fff",
              padding: "8px",
              borderRadius: "6px",
              fontSize: "12px",
              textAlign: "center",
              zIndex: 10,
            }}
          >
            Area putih adalah bagian yang akan disimpan
          </div>
          <div
            style={{
              position: "relative",
              width: "100%",
              height: "100%",
              overflow: "hidden",
            }}
          >
            <img
              src={cropImageSrc}
              alt="Crop"
              style={{
                width: "100%",
                height: "100%",
                objectFit: "contain",
              }}
            />
            {/* Crop overlay */}
            <div
              style={{
                position: "absolute",
                top: "50%",
                left: "50%",
                transform: "translate(-50%, -50%)",
                width: "80%",
                height: "80%",
                border: "2px solid #fff",
                boxShadow: "0 0 0 9999px rgba(0,0,0,0.5)",
                cursor: "move",
              }}
            />
          </div>
          <div
            style={{
              position: "absolute",
              bottom: 20,
              left: 0,
              right: 0,
              display: "flex",
              justifyContent: "center",
              gap: 20,
            }}
          >
            <button
              onClick={handleCropCancel}
              style={{
                background: "#ef4444",
                color: "#fff",
                border: "none",
                borderRadius: "50%",
                width: 40,
                height: 40,
                fontSize: 18,
                fontWeight: "bold",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                cursor: "pointer",
              }}
            >
              ✕
            </button>
            <button
              onClick={async () => {
                try {
                  const response = await fetch(cropImageSrc);
                  const blob = await response.blob();
                  const file = new File([blob], "bukti-perbaikan.jpg", {
                    type: "image/jpeg",
                  });
                  setBuktiPerbaikan(file);
                  setBuktiPreview(cropImageSrc);
                  setShowCropper(false);
                  setCropImageSrc(null);
                } catch (error) {
                  console.error("Error using original image:", error);
                  setError("Gagal memproses gambar. Silakan coba lagi.");
                  setShowCropper(false);
                  setCropImageSrc(null);
                }
              }}
              style={{
                background: "#6b7280",
                color: "#fff",
                border: "none",
                borderRadius: "50%",
                width: 40,
                height: 40,
                fontSize: 12,
                fontWeight: "bold",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                cursor: "pointer",
              }}
              title="Gunakan gambar asli"
            >
              ⭕
            </button>
            <button
              onClick={handleCropConfirm}
              style={{
                background: "#22c55e",
                color: "#fff",
                border: "none",
                borderRadius: "50%",
                width: 40,
                height: 40,
                fontSize: 18,
                fontWeight: "bold",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                cursor: "pointer",
              }}
            >
              ✓
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div style={contentAreaStyle}>
      <div
        style={{
          ...mobileCardStyle,
          marginTop: 0,
          paddingTop: 0,
          // Hapus paddingBottom dan marginBottom yang memaksa height
        }}
      >
        <div style={cardHeaderMobileStyle}>
          <h2
            style={{
              margin: 0,
              fontWeight: 800,
              fontSize: 18, // besarkan lagi
              color: "#2563eb",
              letterSpacing: 1,
              textAlign: "center",
              lineHeight: 1.1, // lebih rapat
            }}
          >
            Take 5
          </h2>
        </div>

        <form onSubmit={handleSubmit} style={formStyle}>
          {/* Tanggal */}
          <div style={fieldMargin}>
            <label style={labelStyle}>Tanggal</label>
            <input
              value={getToday()}
              readOnly
              style={{ ...inputStyle, background: "#e5e7eb", border: "none" }}
            />
          </div>

          {/* Lokasi Kerja */}
          <div style={fieldMargin}>
            <label style={labelStyle}>Lokasi Kerja</label>
            <select
              value={site}
              onChange={(e) => setSite(e.target.value)}
              required
              style={inputStyle}
            >
              <option value="">Pilih Lokasi</option>
              {SITE_OPTIONS.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
          </div>

          {/* Detail Lokasi */}
          <div style={fieldMargin}>
            <label style={labelStyle}>Detail Lokasi</label>
            {allowsCustomInput(site) ? (
              <input
                type="text"
                value={detailLokasi}
                onChange={(e) => setDetailLokasi(e.target.value)}
                required
                placeholder="Ketik detail lokasi..."
                style={inputStyle}
              />
            ) : (
              <>
                <select
                  value={detailLokasi}
                  onChange={handleDetailLokasiChange}
                  required
                  style={inputStyle}
                >
                  <option value="">Pilih Detail Lokasi</option>
                  {locationOptions.map((option) => (
                    <option key={option} value={option}>
                      {option}
                    </option>
                  ))}
                </select>
                {showCustomInput && (
                  <input
                    type="text"
                    value={detailLokasi}
                    onChange={(e) => setDetailLokasi(e.target.value)}
                    required
                    placeholder="Ketik detail lokasi lainnya..."
                    style={{
                      ...inputStyle,
                      marginTop: 8,
                    }}
                  />
                )}
              </>
            )}
          </div>

          {/* Potensi Bahaya */}
          <div style={fieldMargin}>
            <label style={labelStyle}>Potensi Bahaya</label>
            <input
              type="text"
              value={potensiBahaya}
              onChange={(e) => setPotensiBahaya(e.target.value)}
              required
              placeholder="Contoh: Listrik, Ketinggian, dll"
              style={inputStyle}
            />
          </div>

          {/* Pertanyaan 1 */}
          <div style={fieldMargin}>
            <label style={labelStyle}>
              Apakah Saya mengerti pekerjaan yang akan saya lakukan?
            </label>
            <div style={questionBtnGroupStyle}>
              <button
                type="button"
                onClick={() => setQ1(true)}
                style={radioBtnStyle(q1 === true, "#22c55e", false)}
              >
                Ya
              </button>
              <button
                type="button"
                onClick={() => setQ1(false)}
                style={{
                  ...radioBtnStyle(q1 === false, "#ef4444", false),
                  borderWidth: q1 === false ? "3px" : "2px",
                  boxShadow: q1 === false ? "0 0 0 2px #fef3c7" : "none",
                }}
              >
                Tidak
              </button>
            </div>
          </div>

          {/* Pertanyaan 2 */}
          <div style={fieldMargin}>
            <label style={labelStyle}>
              Apakah Saya memiliki kompetensi untuk melakukan pekerjaan ini?
            </label>
            <div style={questionBtnGroupStyle}>
              <button
                type="button"
                onClick={() => setQ2(true)}
                style={radioBtnStyle(q2 === true, "#22c55e", false)}
              >
                Ya
              </button>
              <button
                type="button"
                onClick={() => setQ2(false)}
                style={{
                  ...radioBtnStyle(q2 === false, "#ef4444", false),
                  borderWidth: q2 === false ? "3px" : "2px",
                  boxShadow: q2 === false ? "0 0 0 2px #fef3c7" : "none",
                }}
              >
                Tidak
              </button>
            </div>
          </div>

          {/* Pertanyaan 3 */}
          <div style={fieldMargin}>
            <label style={labelStyle}>
              Apakah Saya memiliki izin untuk melakukan pekerjaan ini?
            </label>
            <div style={questionBtnGroupStyle}>
              <button
                type="button"
                onClick={() => setQ3(true)}
                style={radioBtnStyle(q3 === true, "#22c55e", false)}
              >
                Ya
              </button>
              <button
                type="button"
                onClick={() => setQ3(false)}
                style={{
                  ...radioBtnStyle(q3 === false, "#ef4444", false),
                  borderWidth: q3 === false ? "3px" : "2px",
                  boxShadow: q3 === false ? "0 0 0 2px #fef3c7" : "none",
                }}
              >
                Tidak
              </button>
            </div>
          </div>

          {/* Pertanyaan 4 */}
          <div style={fieldMargin}>
            <label style={labelStyle}>
              Apakah Saya memiliki peralatan yang tepat untuk pekerjaan ini?
            </label>
            <div style={questionBtnGroupStyle}>
              <button
                type="button"
                onClick={() => setQ4(true)}
                style={radioBtnStyle(q4 === true, "#22c55e", false)}
              >
                Ya
              </button>
              <button
                type="button"
                onClick={() => setQ4(false)}
                style={{
                  ...radioBtnStyle(q4 === false, "#ef4444", false),
                  borderWidth: q4 === false ? "3px" : "2px",
                  boxShadow: q4 === false ? "0 0 0 2px #fef3c7" : "none",
                }}
              >
                Tidak
              </button>
            </div>
          </div>

          {/* Aman atau Perbaikan */}
          <div style={fieldMargin}>
            <label style={labelStyle}>
              Apakah kondisi kerja aman untuk melanjutkan pekerjaan?
            </label>
            <div style={amanBtnGroupStyle}>
              <button
                type="button"
                onClick={() => {
                  console.log("Setting aman to:", "aman");
                  setAman("aman");
                }}
                disabled={isAmanButtonDisabled}
                style={{
                  ...amanBtnStyle(aman === "aman", "#22c55e"),
                  opacity: isAmanButtonDisabled ? 0.5 : 1,
                  cursor: isAmanButtonDisabled ? "not-allowed" : "pointer",
                  background: isAmanButtonDisabled
                    ? "#f3f4f6"
                    : aman === "aman"
                    ? "#22c55e"
                    : "#fff",
                  color: isAmanButtonDisabled
                    ? "#9ca3af"
                    : aman === "aman"
                    ? "#fff"
                    : "#22c55e",
                  borderColor: isAmanButtonDisabled ? "#d1d5db" : "#22c55e",
                }}
              >
                Ya
              </button>
              <button
                type="button"
                onClick={() => {
                  console.log("Setting aman to:", "perbaikan");
                  setAman("perbaikan");
                }}
                style={amanBtnStyle(aman === "perbaikan", "#f59e0b")}
              >
                Saya perlu melakukan perbaikan terlebih dahulu, untuk
                melanjutkan pekerjaan
              </button>
              <button
                type="button"
                onClick={() => {
                  console.log("Setting aman to:", "stop");
                  setAman("stop");
                }}
                style={amanBtnStyle(aman === "stop", "#ef4444")}
              >
                STOP pekerjaan, lalu minta bantuan untuk perbaikan
              </button>
            </div>
          </div>

          {/* Bukti Perbaikan */}
          {(aman === "perbaikan" || aman === "stop") && (
            <>
              <div style={fieldMargin}>
                <label style={labelStyle}>
                  {aman === "stop"
                    ? "Bukti Kondisi (Foto)"
                    : "Bukti Perbaikan (Foto)"}
                </label>
                <input
                  type="file"
                  accept="image/*"
                  capture="environment"
                  // required (hapus ini)
                  style={{ display: "none" }}
                  id="bukti-file-input"
                  name="bukti"
                  onChange={handleBuktiChange}
                />
                {buktiPreview ? (
                  <div style={{ textAlign: "center" }}>
                    <img
                      src={buktiPreview}
                      alt="Preview"
                      onClick={() =>
                        document.getElementById("bukti-file-input").click()
                      }
                      style={{
                        maxWidth: "100%",
                        maxHeight: 200,
                        borderRadius: 8,
                        marginTop: 8,
                        border: "2px solid #e5e7eb",
                        cursor: "pointer",
                      }}
                      title="Klik untuk ganti foto"
                    />
                  </div>
                ) : (
                  <button
                    type="button"
                    onClick={() =>
                      document.getElementById("bukti-file-input").click()
                    }
                    style={{
                      width: "100%",
                      background: "#f3f4f6",
                      border: "2px dashed #d1d5db",
                      borderRadius: 8,
                      padding: "12px",
                      fontSize: 13,
                      color: "#6b7280",
                      cursor: "pointer",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      gap: "8px",
                    }}
                  >
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    >
                      <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z" />
                      <circle cx="12" cy="13" r="4" />
                    </svg>
                    Klik untuk mengambil foto
                  </button>
                )}
              </div>

              <div style={fieldMargin}>
                <label style={labelStyle}>
                  {aman === "stop"
                    ? "Deskripsi Kondisi"
                    : "Deskripsi Perbaikan"}
                </label>
                <textarea
                  value={
                    aman === "stop" ? deskripsiKondisi : deskripsiPerbaikan
                  }
                  onChange={(e) =>
                    aman === "stop"
                      ? setDeskripsiKondisi(e.target.value)
                      : setDeskripsiPerbaikan(e.target.value)
                  }
                  // required (hapus ini untuk menghindari error)
                  placeholder={
                    aman === "stop"
                      ? "Jelaskan kondisi yang tidak aman dan mengapa perlu bantuan"
                      : "Jelaskan perbaikan yang telah dilakukan"
                  }
                  style={{
                    ...inputStyle,
                    minHeight: 80,
                    resize: "vertical",
                  }}
                />
              </div>
            </>
          )}

          {/* Error Message */}
          {error && (
            <div
              style={{
                color: "#b91c1c",
                fontWeight: 700,
                background: "#fee2e2",
                borderRadius: 8,
                padding: 6,
                border: "1.5px solid #b91c1c",
                fontSize: 13,
              }}
            >
              {error}
            </div>
          )}

          {/* Success Message */}
          {success && (
            <div
              style={{
                color: "#16a34a",
                fontWeight: 700,
                background: "#dcfce7",
                borderRadius: 8,
                padding: 6,
                border: "1.5px solid #22c55e",
                fontSize: 13,
              }}
            >
              {aman === "stop"
                ? "Data Take 5 berhasil disimpan! Akan dialihkan ke Hazard Report..."
                : "Data Take 5 berhasil disimpan! Status: Closed"}
            </div>
          )}

          {/* Submit Button fixed di bawah card */}
          <div
            style={{
              position: "fixed",
              left: 0,
              right: 0,
              bottom: 56,
              zIndex: 100,
              maxWidth: 425,
              margin: "0 auto",
            }}
          >
            <button
              type="submit"
              disabled={!isFormValid || loading}
              style={{
                background: "#2563eb",
                color: "#fff",
                border: "none",
                borderTopLeftRadius: 12,
                borderTopRightRadius: 12,
                borderBottomLeftRadius: 0,
                borderBottomRightRadius: 0,
                padding: "12px 0",
                fontSize: 14,
                fontWeight: 600,
                cursor: "pointer",
                width: "100%",
                boxShadow: "0 -2px 8px #0001",
              }}
            >
              {loading ? "Menyimpan..." : "Simpan Take 5"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Take5FormMobile;
