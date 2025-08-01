import React, { useState, useEffect } from "react";
import Dropzone from "./components/Dropzone/Dropzone";
import UploadKaryawan from "./components/Dropzone/UploadKaryawan";
import HazardForm from "./components/HazardForm/index.jsx";
import Login from "./components/Login";
import FitToWorkForm from "./components/FitToWorkForm";
import FitToWorkValidation from "./components/FitToWorkValidation";
import FitToWorkValidationNew from "./components/FitToWorkValidationNew";
import Take5Form from "./components/Take5Form/index.jsx";
import MonitoringPage from "./components/MonitoringPage";
import "./App.css";
import { supabase } from "./supabaseClient";
import TasklistForm from "./components/tasklistForms/index.jsx";
import Profile from "./components/Profile/index.jsx";

// Test component untuk validasi baru
function TestFitToWorkValidationNew() {
  const [user, setUser] = useState({
    nama: "Armando Y. Butar Butar",
    jabatan: "Penanggung Jawab Operasional",
    site: "BSIB",
    role: "evaluator",
  });

  return (
    <div style={{ padding: "20px" }}>
      <h1>Test Fit To Work Validation New</h1>
      <FitToWorkValidationNew user={user} />
    </div>
  );
}

export default TestFitToWorkValidationNew;
