<?php

$finder = PhpCsFixer\Finder::create()
    ->in([
        __DIR__.'/src',
        __DIR__.'/tests',
        __DIR__.'/migrations'
    ]);

return (new PhpCsFixer\Config())
    ->setRiskyAllowed(true)
    ->setRules([
        '@Symfony' => true,
        '@Symfony:risky' => true,

        'array_syntax' => ['syntax' => 'short'],
        'blank_line_between_import_groups' => true,
        'combine_consecutive_unsets' => true,
        'declare_equal_normalize' => true,
        'declare_strict_types' => true,
        'full_opening_tag' => true,
        'heredoc_to_nowdoc' => true,
        'linebreak_after_opening_tag' => true,
        'mb_str_functions' => true,
        'method_chaining_indentation' => true,
        'no_php4_constructor' => true,
        'no_unreachable_default_argument_value' => true,
        'no_useless_else' => true,
        'no_useless_return' => true,
        'ordered_class_elements' => true,
        'php_unit_strict' => true,
        'php_unit_test_case_static_method_calls' => ['call_type' => 'static'],
        'phpdoc_add_missing_param_annotation' => true,
        'phpdoc_inline_tag_normalizer' => [
            'tags' => [
                'example',
                'id',
                'internal',
                'inheritdoc',
                'inheritdocs',
                'link',
                'source',
                'toc',
                'tutorial',
            ],
        ],
        'phpdoc_order' => true,
        'strict_comparison' => true,
        'ternary_operator_spaces' => true,
        'ternary_to_null_coalescing' => true,
    ])
    ->setFinder($finder)
    ->setCacheFile(__DIR__.'/var/.php-cs-fixer.cache');
