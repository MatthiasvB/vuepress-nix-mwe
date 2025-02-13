import { defineUserConfig } from "vuepress";

import theme from "./theme.js";

export default defineUserConfig({
  base: "/",

  lang: "en-US",
  title: "Nixxer Docs",
  description: "Documentation around nix",

  theme,

  // Enable it with pwa
  // shouldPrefetch: false,
});
