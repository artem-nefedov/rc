-- snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("sh", {
  s("ssc", { t("# shellcheck disable=") })
})
