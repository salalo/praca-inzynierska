import React from "react";
import { StateContextProvider } from "./context";
import App from "./App";
import { BrowserRouter as Router } from "react-router-dom";
import { createRoot } from "react-dom/client";
import { ThirdwebProvider } from "@thirdweb-dev/react";
import { Sepolia } from "@thirdweb-dev/chains";
import "./index.css";

const container = document.getElementById("root");
const root = createRoot(container);

root.render(
  <ThirdwebProvider
    clientId="93493f284fb8d664dd14bcf113175974"
    activeChain={Sepolia}
  >
    <Router>
      <StateContextProvider>
        <App />
      </StateContextProvider>
    </Router>
  </ThirdwebProvider>
);
