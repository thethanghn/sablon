# Sablon

[![Gem Version](https://badge.fury.io/rb/sablon.svg)](http://badge.fury.io/rb/sablon) [![Build Status](https://travis-ci.org/senny/sablon.svg?branch=master)](https://travis-ci.org/senny/sablon)

Is a document template processor for Word `docx` files. It leverages Word's
built-in formatting and layouting capabilities to make template creation easy
and efficient.

*Note: Sablon is still in early development. Please report if you encounter any issues along the way.*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sablon', git: 'git@github.com:thethanghn/sablon.git'
```

#### Content Insertion

This fork allows you to use simple TOKEN replacement:

```
[MY NAME]
```

NOTE: alphabetical, space, hyphen and dash are allowed in tokens

## Inspiration

All credits go to this gem Sablon

* [sablon](https://github.com/senny/sablon)
