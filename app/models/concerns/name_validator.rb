class NameValidator < ActiveModel::Validator
  def validate(record)
    all_records = record.class.where(user: record.user).where.not(id: record.id)
    records_same_name = all_records.where('lower(name) = ?', record.name.downcase)
    if !(records_same_name.empty?)
      record.errors.add :name, "#{records_same_name.first.name} is already an existing #{record.class.name}"
    end
  end
end
