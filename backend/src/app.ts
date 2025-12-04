import express from "express";
import cors from "cors";

// IMPORT CORRECTO — SIN LA "s"
import expenseRoutes from "./routes/expense.route";

const app = express();

app.use(cors());
app.use(express.json());

// mount routes
app.use("/api", expenseRoutes);

// healthcheck
app.get("/health", (req, res) => {
  res.send("Backend OK");
});

export default app;
