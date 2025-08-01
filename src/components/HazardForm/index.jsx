import React, { useState, useEffect } from "react";
import HazardFormDesktop from "./HazardFormDesktop";
import HazardFormMobile from "./HazardFormMobile";

function HazardForm({ user }) {
  const [isMobile, setIsMobile] = useState(window.innerWidth <= 768);

  useEffect(() => {
    const handleResize = () => {
      setIsMobile(window.innerWidth <= 768);
    };

    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  return isMobile ? (
    <HazardFormMobile user={user} />
  ) : (
    <HazardFormDesktop user={user} />
  );
}

export default HazardForm;
