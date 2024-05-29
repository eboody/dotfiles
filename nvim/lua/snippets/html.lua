local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require 'luasnip.util.events'
local ai = require 'luasnip.nodes.absolute_indexer'
local extras = require 'luasnip.extras'
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local conds = require 'luasnip.extras.expand_conditions'
local postfix = require('luasnip.extras.postfix').postfix
local types = require 'luasnip.util.types'
local parse = require('luasnip.util.parser').parse_snippet
local ms = ls.multi_snippet
local k = require('luasnip.nodes.key_indexer').new_key

return {
  -- HTML Boilerplate
  s(
    'html',
    fmt(
      [[
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{}</title>
    <link rel="stylesheet" href="{}">
  </head>
  <body>
    {}
  </body>
  </html>
  ]],
      {
        i(1, 'Document Title'),
        i(2, 'styles.css'),
        i(3, 'Content goes here...'),
      }
    )
  ),
  -- Link Tag
  s(
    'link',
    fmt('<a href="{}">{}</a>', {
      i(1, 'https://example.com'),
      i(2, 'Example Link'),
    })
  ),
  -- Image Tag
  s(
    'img',
    fmt('<img src="{}" alt="{}"{}>', {
      i(1, 'image.png'),
      i(2, 'Description'),
      i(3, ' width="{}" height="{}"'),
    })
  ),
  -- Unordered List
  s(
    'ul',
    fmt(
      [[
  <ul>
    <li>{}</li>
    <li>{}</li>
    <li>{}</li>
  </ul>
  ]],
      {
        i(1, 'Item 1'),
        i(2, 'Item 2'),
        i(3, 'Item 3'),
      }
    )
  ),
  -- Table
  s(
    'table',
    fmt(
      [[
  <table>
    <thead>
      <tr>
        <th>{}</th>
        <th>{}</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>{}</td>
        <td>{}</td>
      </tr>
      <tr>
        <td>{}</td>
        <td>{}</td>
      </tr>
    </tbody>
  </table>
  ]],
      {
        i(1, 'Header 1'),
        i(2, 'Header 2'),
        i(3, 'Data 1'),
        i(4, 'Data 2'),
        i(5, 'Data 3'),
        i(6, 'Data 4'),
      }
    )
  ),
  -- Form
  s(
    'form',
    fmt(
      [[
  <form action="{}" method="{}">
    <label for="{}">{}</label>
    <input type="{}" id="{}" name="{}" value="{}">
    <button type="submit">{}</button>
  </form>
  ]],
      {
        i(1, 'submit.php'),
        i(2, 'post'),
        i(3, 'name'),
        i(4, 'Name:'),
        i(5, 'text'),
        i(6, 'name'),
        i(7, 'name'),
        i(8, ''),
        i(9, 'Submit'),
      }
    )
  ),
  -- Style Tag
  s(
    'style',
    fmt(
      [[
<style>
  {}
</style>
]],
      {
        i(1, '/* CSS code here */'),
      }
    )
  ),

  -- Script Tag
  s(
    'script',
    fmt(
      [[
<script>
  {}
</script>
]],
      {
        i(1, '// JavaScript code here'),
      }
    )
  ),

  -- Div Tag
  s(
    'div',
    fmt(
      [[
<div class="{}">
  {}
</div>
]],
      {
        i(1, 'container'),
        i(2, 'Content here'),
      }
    )
  ),

  -- Span Tag
  s(
    'span',
    fmt(
      [[
<span class="{}">
  {}
</span>
]],
      {
        i(1, 'text'),
        i(2, 'Inline text here'),
      }
    )
  ),

  -- Header Tag
  s(
    'header',
    fmt(
      [[
<header>
  {}
</header>
]],
      {
        i(1, 'Header content here'),
      }
    )
  ),

  -- Footer Tag
  s(
    'footer',
    fmt(
      [[
<footer>
  {}
</footer>
]],
      {
        i(1, 'Footer content here'),
      }
    )
  ),

  -- Section Tag
  s(
    'section',
    fmt(
      [[
<section>
  {}
</section>
]],
      {
        i(1, 'Section content here'),
      }
    )
  ),

  -- Article Tag
  s(
    'article',
    fmt(
      [[
<article>
  {}
</article>
]],
      {
        i(1, 'Article content here'),
      }
    )
  ),

  -- Nav Tag
  s(
    'nav',
    fmt(
      [[
<nav>
  {}
</nav>
]],
      {
        i(1, 'Navigation links here'),
      }
    )
  ),

  -- Button Tag
  s(
    'button',
    fmt(
      [[
<button type="{}" class="{}">
  {}
</button>
]],
      {
        i(1, 'button'),
        i(2, 'btn'),
        i(3, 'Button text'),
      }
    )
  ),

  -- Input Tag
  s(
    'input',
    fmt(
      [[
<input type="{}" name="{}" id="{}" value="{}">
]],
      {
        i(1, 'text'),
        i(2, 'name'),
        i(3, 'name'),
        i(4, ''),
      }
    )
  ),
}
