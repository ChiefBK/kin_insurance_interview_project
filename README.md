
# Configuration
Developed using Ruby 2.7.2

# Example
```
# Load "policy_ocr.rb" file

# Parses file and deserializes into policy number objects
policy_numbers = PolicyOcr.parse_file('<path_to_spec_folder>/spec/fixtures/sample.txt')

# Prints policy numbers
policy_numbers.map(&:to_string)
```