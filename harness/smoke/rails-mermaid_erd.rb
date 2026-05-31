# Drive RailsMermaidErd::MermaidText with a synthetic model_data hash
# No Rails, no yaml, no external gems needed - pure string transforms

puts RailsMermaidErd::VERSION

puts RailsMermaidErd::MermaidText::HEADER.length

result = {
  Models: [
    {
      TableName: "users",
      TableComment: "App users",
      ModelName: "User",
      Columns: [
        { type: "bigint", name: "id", key: "PK", comment: "" },
        { type: "varchar", name: "email", key: "", comment: "user email" }
      ]
    },
    {
      TableName: "posts",
      TableComment: "",
      ModelName: "Admin::Post",
      Columns: [
        { type: "bigint", name: "id", key: "PK", comment: "primary key" },
        { type: "bigint", name: "user_id", key: "FK", comment: "" }
      ]
    }
  ],
  Relations: [
    {
      LeftModelName: "User",
      RightModelName: "Admin::Post",
      LeftValue: "||",
      Line: "--",
      RightValue: "o{",
      Comment: "has many"
    }
  ]
}

text = RailsMermaidErd::MermaidText.build(result)
puts text
