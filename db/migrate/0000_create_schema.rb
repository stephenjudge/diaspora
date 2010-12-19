class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :aspects do |t|
      t.string :name
      t.integer :user_id
      t.timestamps
    end
    add_index :aspects, :user_id

    create_table :aspect_memberships do |t|
      t.boolean :pending, :default => true
      t.integer :aspect_id
      t.integer :person_id
      t.timestamps
    end
    add_index :aspect_memberships, :aspect_id
    add_index :aspect_memberships, [:aspect_id, :person_id], :unique => true

    create_table :aspects_posts, :id => false do |t|
      t.integer :aspect_id
      t.integer :post_id
      t.timestamps
    end
    add_index :aspects_posts, :aspect_id
    add_index :aspects_posts, :post_id

    create_table :comments do |t|
      t.text :text
      t.integer :post_id
      t.integer :person_id
      t.string :guid
      t.text :creator_signature
      t.text :post_creator_signature
      t.timestamps
    end
    add_index :comments, :guid, :unique => true
    add_index :comments, :post_id

    create_table :invitations do |t|
      t.text :message
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :aspect_id
      t.timestamps
    end
    add_index :invitations, :sender_id

    create_table :notifications do |t|
      t.string :target_type
      t.integer :target_id
      t.integer :receiver_id
      t.integer :actor_id
      t.string :action
      t.boolean :unread, :default => true
      t.timestamps
    end
    add_index :notifications, [:target_type, :target_id]

    create_table :people do |t|
      t.string :guid
      t.text :url
      t.string :diaspora_handle
      t.text :serialized_public_key
      t.integer :owner_id
      t.timestamps
    end
    add_index :people, :guid, :unique => true
    add_index :people, :owner_id, :unique => true
    add_index :people, :diaspora_handle, :unique => true

    create_table :profiles do |t|
      t.string :diaspora_handle
      t.string :first_name
      t.string :last_name
      t.string :image_url
      t.string :image_url_small
      t.string :image_url_medium
      t.date :birthday
      t.string :gender
      t.text :bio
      t.boolean :searchable, :default => true
      t.integer :person_id
      t.timestamps
    end
    add_index :profiles, [:first_name, :searchable]
    add_index :profiles, [:last_name, :searchable]
    add_index :profiles, [:first_name, :last_name, :searchable]
    add_index :profiles, :person_id
  end

  def self.down
    raise "irreversable migration!"
  end
end