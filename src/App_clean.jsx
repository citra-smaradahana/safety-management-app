import React, { useState, useEffect } from "react";
import { supabase } from "./supabaseClient";
import Login from "./components/Login";
import Profile from "./components/Profile";
import HazardForm from "./components/HazardForm";
import FitToWorkForm from "./components/FitToWorkForm";
import FitToWorkValidationNew from "./components/FitToWorkValidationNew";
import MonitoringPage from "./components/MonitoringPage";
import UserManagement from "./components/UserManagement";
import { siteLocations } from "./config/siteLocations";

  if (status === "Closed") {
    return (
      <TasklistForm
        user={user}
        status="Done"
        hazard={selectedHazard}
        readOnly={getReadOnly("Done", selectedHazard)}
        onSuccess={handleCloseCard}
        onClose={handleCloseCard}
      />
    );
  }
  return null;
} 