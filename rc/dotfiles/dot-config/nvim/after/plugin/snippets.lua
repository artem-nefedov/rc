-- snippets

local ls = require("luasnip")
local parse = ls.parser.parse_snippet
local s = ls.snippet
local t = ls.text_node
-- local i = ls.insert_node
local c = ls.choice_node

ls.add_snippets("sh", {
  s("ssc", { t("# shellcheck disable=") }),
  s("sss", { t("# shellcheck source=") }),
  s("sd", { t('script_dir=$(cd "$(dirname "$0")" && pwd)') }),
  s("#!", c(1, {
    t("#!/usr/bin/env bash"),
    t("#!/usr/bin/env sh"),
  })),
  parse("wr", "while read -r ${1:varname}; do\n\t$0\ndone"),
})

-- from friendly-snippets
ls.add_snippets("go", {
  parse("pkgm", "package main\n\nfunc main() {\n\t$0\n}"),
  parse("func", "func $1($2) $3 {\n\t$0\n}"),
  parse("switch", "switch ${1:expression} {\ncase ${2:condition}:\n\t$0\n}"),
  parse("sel", "select {\ncase ${1:condition}:\n\t$0\n}"),
  parse("for", "for ${1}{\n\t$0\n}"),
  parse("fori", "for ${1:i} := ${2:0}; $1 < ${3:count}; $1${4:++} {\n\t$0\n}"),
  parse("forr", "for ${1:_, }${2:v} := range ${3:v} {\n\t$0\n}"),
  parse("map", "map[${1:type}]${2:type}"),
  parse("if", "if ${1:condition} {\n\t$0\n}"),
  parse("el", "else {\n\t$0\n}"),
  parse("ir", "if err != nil {\n\t${1:return ${2:nil, }${3:err}}\n}"),
  parse("fp", "fmt.Println(\"$1\")"),
  parse("ff", "fmt.Printf(\"$1\", ${2:var})"),
})

ls.add_snippets("markdown", {
  parse("uu", "* Upgrade $1 helm chart to $0"),
})
