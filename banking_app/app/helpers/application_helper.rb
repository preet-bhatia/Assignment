module ApplicationHelper
    def convert_timestamp_to_ist(timestamp)
        timestamp.time.in_time_zone(TZInfo::Timezone.get('Asia/Kolkata'))
    end
end
