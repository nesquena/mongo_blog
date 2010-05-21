class Post
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :title,     :type => String
  field :body,      :type => String
  field :permalink, :type => String
  field :tags,      :type => Array
  
  
  before_save :to_permalink
  
  def to_permalink
    self.permalink = self.title.gsub(' ','_').gsub(/\W/,'').downcase
  end
    
end
