import React, { useState } from "react";
import { supabase } from "../supabaseClient";

function Login({ onLogin }) {
  const [user, setUser] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);
    const { data, error: queryError } = await supabase
      .from("users")
      .select("*")
      .eq("user", user)
      .eq("password", password)
      .single();
    setLoading(false);
    if (queryError || !data) {
      setError("User atau Password salah!");
    } else {
      onLogin(data);
    }
  };

  return (
    <div
      style={{
        minHeight: "100vh",
        minWidth: "100vw",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        background: "none",
      }}
    >
      <form onSubmit={handleSubmit} className="glass-card login-glass-card">
        <div style={{ textAlign: "center", marginBottom: 18 }}>
          <div
            style={{
              width: 64,
              height: 64,
              margin: "0 auto 16px auto",
              borderRadius: "50%",
              background: "linear-gradient(135deg, #6366f1 60%, #06b6d4 100%)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              boxShadow: "0 2px 8px #6366f133",
            }}
          >
            <svg width="32" height="32" fill="#fff" viewBox="0 0 24 24">
              <path d="M12 12c2.7 0 8 1.34 8 4v2H4v-2c0-2.66 5.3-4 8-4zm0-2a4 4 0 1 1 0-8 4 4 0 0 1 0 8z" />
            </svg>
          </div>
          <h2
            style={{
              fontWeight: 700,
              fontSize: 28,
              color: "#fff",
              margin: 0,
              letterSpacing: "-1px",
            }}
          >
            Sign In
          </h2>
          <p style={{ color: "#a5b4fc", fontSize: 15, margin: 0 }}>
            Masuk ke akun Anda
          </p>
        </div>
        <label style={{ fontWeight: 500, color: "#fff" }}>
          Username
          <div style={{ position: "relative" }}>
            <span
              style={{
                position: "absolute",
                left: 12,
                top: 10,
                color: "#94a3b8",
              }}
            >
              <svg
                width="18"
                height="18"
                fill="none"
                stroke="#94a3b8"
                strokeWidth="2"
                viewBox="0 0 24 24"
              >
                <path d="M16 21v-2a4 4 0 0 0-8 0v2" />
                <circle cx="12" cy="7" r="4" />
              </svg>
            </span>
            <input
              value={user}
              onChange={(e) => setUser(e.target.value)}
              required
              style={{
                width: "100%",
                padding: "10px 12px 10px 38px",
                marginTop: "6px",
                marginBottom: 0,
                border: "1.5px solid #cbd5e1",
                borderRadius: 8,
                fontSize: 16,
                outline: "none",
                transition: "border 0.2s",
                background: "#f8fafc",
                boxSizing: "border-box",
              }}
              autoFocus
            />
          </div>
        </label>
        <label style={{ fontWeight: 500, color: "#fff" }}>
          Password
          <div style={{ position: "relative" }}>
            <span
              style={{
                position: "absolute",
                left: 12,
                top: 10,
                color: "#94a3b8",
              }}
            >
              <svg
                width="18"
                height="18"
                fill="none"
                stroke="#94a3b8"
                strokeWidth="2"
                viewBox="0 0 24 24"
              >
                <rect x="3" y="11" width="18" height="11" rx="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
            </span>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              style={{
                width: "100%",
                padding: "10px 12px 10px 38px",
                marginTop: "6px",
                marginBottom: 0,
                border: "1.5px solid #cbd5e1",
                borderRadius: 8,
                fontSize: 16,
                outline: "none",
                transition: "border 0.2s",
                background: "#f8fafc",
                boxSizing: "border-box",
              }}
            />
          </div>
        </label>
        <button
          type="submit"
          disabled={loading}
          style={{
            width: "100%",
            marginTop: 8,
            cursor: loading ? "not-allowed" : "pointer",
          }}
        >
          {loading ? "Loading..." : "Login"}
        </button>
        {error && (
          <p style={{ color: "#ef4444", textAlign: "center", margin: 0 }}>
            {error}
          </p>
        )}
      </form>
    </div>
  );
}

export default Login;
