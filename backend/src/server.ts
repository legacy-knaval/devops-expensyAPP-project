// Cargar variables de entorno (solo local)
if (process.env.NODE_ENV !== "production") {
  require("dotenv").config();
}

import app from "./app";
import connectDB from "./config/db.config";

const port = process.env.PORT || 3001;

(async () => {
  await connectDB();

  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
})();