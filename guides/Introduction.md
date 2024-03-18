Filament is a library that was heavily inspired by its namesake in the PHP world. 

This section is basicallly to note down all my ideas so I don't forget them.

Example of a Form
```
%{
      module: Filament.Pets.Pet,
      fields: [
        :name,
        %{
          name: :type,
          label: "Genus of Animal",
          html_type: :select,
          options: %{
            "dog" => "Dog",
            "cat" => "Cat",
            "rabbit" => "Rabbit"
          }
        },
        :date_of_birth,
        %{
          name: :owner_id,
          queryable: &not_first/0,
          value: :name
        }
      ],
      changeset: :name_changeset
    }
```