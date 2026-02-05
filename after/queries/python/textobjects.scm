; Functions
(function_definition) @function.outer
(function_definition
  body: (block) @function.inner)

; Classes
(class_definition) @class.outer
(class_definition
  body: (block) @class.inner)

; Parameters
(parameters (identifier) @parameter.inner) @parameter.outer
(parameters (typed_parameter (identifier) @parameter.inner)) @parameter.outer
(parameters (default_parameter (identifier) @parameter.inner)) @parameter.outer

; Strings
(string) @string.outer
(string (string_content) @string.inner)
