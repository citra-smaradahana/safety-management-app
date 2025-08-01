// Debug script untuk test update user
// Jalankan di browser console

// Test Supabase connection
async function testSupabaseConnection() {
  console.log("=== TESTING SUPABASE CONNECTION ===");

  try {
    const { data, error } = await supabase.from("users").select("*").limit(1);

    if (error) {
      console.error("Supabase connection failed:", error);
      return false;
    }

    console.log("Supabase connection successful:", data);
    return true;
  } catch (err) {
    console.error("Supabase connection error:", err);
    return false;
  }
}

// Test manual update
async function testManualUpdate() {
  console.log("=== TESTING MANUAL UPDATE ===");

  try {
    const testData = {
      nama: "Test Update " + new Date().toISOString(),
    };

    console.log("Updating with data:", testData);

    const { data, error } = await supabase
      .from("users")
      .update(testData)
      .eq("id", "d443523c-86eb-4758-aa79-ca8586b60927")
      .select();

    if (error) {
      console.error("Update failed:", error);
      return false;
    }

    console.log("Update successful:", data);
    return true;
  } catch (err) {
    console.error("Update error:", err);
    return false;
  }
}

// Run tests
async function runTests() {
  console.log("Starting debug tests...");

  const connectionOk = await testSupabaseConnection();
  if (!connectionOk) {
    console.error("Connection test failed, stopping...");
    return;
  }

  const updateOk = await testManualUpdate();
  if (updateOk) {
    console.log("All tests passed!");
  } else {
    console.error("Update test failed!");
  }
}

// Export untuk digunakan di console
window.debugUserUpdate = runTests;
