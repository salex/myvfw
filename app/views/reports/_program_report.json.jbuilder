json.extract! program_report, :id, :type_report, :date, :details, :area, :remarks, :volunteers, :hours_each, :miles_each, :expenses, :total_hours, :total_miles, :updated_by, :created_at, :updated_at
json.url program_report_url(program_report, format: :json)
