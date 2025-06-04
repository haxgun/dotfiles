#!/bin/bash

# Temperature thresholds
CPU_WARNING=70
CPU_CRITICAL=85
GPU_WARNING=75
GPU_CRITICAL=90
NVME_WARNING=70
NVME_CRITICAL=80

# Get main CPU temperature for display
cpu_temp_raw=$(sensors k10temp-pci-00c3 | grep 'Tctl:' | awk '{print $2}' | sed 's/+//g' | sed 's/°C//g')
cpu_temp=${cpu_temp_raw%.*}  # Remove decimal part

# Determine status and class based on highest temperature
max_temp=0
status_class="normal"
status_icon=""

# Function to update max temperature and status
update_status() {
    local temp=$1
    local warning_threshold=$2
    local critical_threshold=$3
    
    if [[ $temp -gt $max_temp ]]; then
        max_temp=$temp
    fi
    
    if [[ $temp -ge $critical_threshold ]]; then
        status_class="critical"
        status_icon="󰚽 "
    elif [[ $temp -ge $warning_threshold && $status_class != "critical" ]]; then
        status_class="warning"
        status_icon="󰀦 "
    elif [[ $status_class == "normal" ]]; then
        status_icon=" "
    fi
}

# Collect all temperatures for tooltip
tooltip=" System Temperatures:\\n\\n"

# CPU temperatures (k10temp)
tooltip+="  AMD Processor:\\n"
while IFS= read -r line; do
    if [[ $line == *"Tctl:"* ]]; then
        temp=$(echo "$line" | awk '{print $2}')
        temp_num=${temp%.*}
        temp_num=${temp_num#+}
        temp_num=${temp_num%°C}
        update_status $temp_num $CPU_WARNING $CPU_CRITICAL
        
        # Add warning/critical indicators
        if [[ $temp_num -ge $CPU_CRITICAL ]]; then
            tooltip+=" • Tctl: $temp  CRITICAL\\n"
        elif [[ $temp_num -ge $CPU_WARNING ]]; then
            tooltip+=" • Tctl: $temp  WARNING\\n"
        else
            tooltip+=" • Tctl: $temp\\n"
        fi
    elif [[ $line == *"Tccd"* ]]; then
        label=$(echo "$line" | awk '{print $1}')
        temp=$(echo "$line" | awk '{print $2}')
        temp_num=${temp%.*}
        temp_num=${temp_num#+}
        temp_num=${temp_num%°C}
        update_status $temp_num $CPU_WARNING $CPU_CRITICAL
        
        if [[ $temp_num -ge $CPU_CRITICAL ]]; then
            tooltip+=" • $label: $temp  CRITICAL\\n"
        elif [[ $temp_num -ge $CPU_WARNING ]]; then
            tooltip+=" • $label: $temp  WARNING\\n"
        else
            tooltip+=" • $label: $temp\\n"
        fi
    fi
done < <(sensors k10temp-pci-00c3 2>/dev/null)

# GPU temperatures (NVIDIA/AMD)
gpu_found=false
tooltip+="\\n  Graphics Card:\\n"

# Check for NVIDIA GPU
if command -v nvidia-smi &> /dev/null; then
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
    if [[ -n "$gpu_temp" ]]; then
        update_status $gpu_temp $GPU_WARNING $GPU_CRITICAL
        
        if [[ $gpu_temp -ge $GPU_CRITICAL ]]; then
            tooltip+=" • GPU Core: +${gpu_temp}°C  CRITICAL\\n"
        elif [[ $gpu_temp -ge $GPU_WARNING ]]; then
            tooltip+=" • GPU Core: +${gpu_temp}°C  WARNING\\n"
        else
            tooltip+=" • GPU Core: +${gpu_temp}°C\\n"
        fi
        gpu_found=true
    fi
fi

# Check for AMD GPU (amdgpu)
if ! $gpu_found; then
    while IFS= read -r line; do
        if [[ $line == *"edge:"* ]]; then
            temp=$(echo "$line" | awk '{print $2}')
            temp_num=${temp%.*}
            temp_num=${temp_num#+}
            temp_num=${temp_num%°C}
            update_status $temp_num $GPU_WARNING $GPU_CRITICAL
            
            if [[ $temp_num -ge $GPU_CRITICAL ]]; then
                tooltip+=" • GPU Edge: $temp  CRITICAL\\n"
            elif [[ $temp_num -ge $GPU_WARNING ]]; then
                tooltip+=" • GPU Edge: $temp  WARNING\\n"
            else
                tooltip+=" • GPU Edge: $temp\\n"
            fi
            gpu_found=true
        elif [[ $line == *"junction:"* ]]; then
            temp=$(echo "$line" | awk '{print $2}')
            temp_num=${temp%.*}
            temp_num=${temp_num#+}
            temp_num=${temp_num%°C}
            update_status $temp_num $GPU_WARNING $GPU_CRITICAL
            
            if [[ $temp_num -ge $GPU_CRITICAL ]]; then
                tooltip+=" • GPU Junction: $temp  CRITICAL\\n"
            elif [[ $temp_num -ge $GPU_WARNING ]]; then
                tooltip+=" • GPU Junction: $temp  WARNING\\n"
            else
                tooltip+=" • GPU Junction: $temp\\n"
            fi
        elif [[ $line == *"mem:"* ]]; then
            temp=$(echo "$line" | awk '{print $2}')
            temp_num=${temp%.*}
            temp_num=${temp_num#+}
            temp_num=${temp_num%°C}
            update_status $temp_num $GPU_WARNING $GPU_CRITICAL
            
            if [[ $temp_num -ge $GPU_CRITICAL ]]; then
                tooltip+=" • GPU Memory: $temp  CRITICAL\\n"
            elif [[ $temp_num -ge $GPU_WARNING ]]; then
                tooltip+=" • GPU Memory: $temp  WARNING\\n"
            else
                tooltip+=" • GPU Memory: $temp\\n"
            fi
        fi
    done < <(sensors amdgpu-pci-* 2>/dev/null)
fi

# If no dedicated GPU found
if ! $gpu_found; then
    tooltip+=" • No dedicated GPU detected\\n"
fi

# NVMe SSD temperatures
tooltip+="\\n󰋊 NVMe Storage:\\n"
while IFS= read -r line; do
    if [[ $line == *"Composite:"* ]]; then
        temp=$(echo "$line" | awk '{print $2}')
        temp_num=${temp%.*}
        temp_num=${temp_num#+}
        temp_num=${temp_num%°C}
        update_status $temp_num $NVME_WARNING $NVME_CRITICAL
        
        if [[ $temp_num -ge $NVME_CRITICAL ]]; then
            tooltip+=" • Composite: $temp  CRITICAL\\n"
        elif [[ $temp_num -ge $NVME_WARNING ]]; then
            tooltip+=" • Composite: $temp  WARNING\\n"
        else
            tooltip+=" • Composite: $temp\\n"
        fi
    elif [[ $line == *"Sensor 1:"* ]]; then
        temp=$(echo "$line" | awk '{print $3}')
        temp_num=${temp%.*}
        temp_num=${temp_num#+}
        temp_num=${temp_num%°C}
        update_status $temp_num $NVME_WARNING $NVME_CRITICAL
        
        if [[ $temp_num -ge $NVME_CRITICAL ]]; then
            tooltip+=" • Sensor 1: $temp  CRITICAL\\n"
        elif [[ $temp_num -ge $NVME_WARNING ]]; then
            tooltip+=" • Sensor 1: $temp  WARNING\\n"
        else
            tooltip+=" • Sensor 1: $temp\\n"
        fi
    elif [[ $line == *"Sensor 2:"* ]]; then
        temp=$(echo "$line" | awk '{print $3}')
        temp_num=${temp%.*}
        temp_num=${temp_num#+}
        temp_num=${temp_num%°C}
        update_status $temp_num $NVME_WARNING $NVME_CRITICAL
        
        if [[ $temp_num -ge $NVME_CRITICAL ]]; then
            tooltip+=" • Sensor 2: $temp  CRITICAL\\n"
        elif [[ $temp_num -ge $NVME_WARNING ]]; then
            tooltip+=" • Sensor 2: $temp  WARNING\\n"
        else
            tooltip+=" • Sensor 2: $temp\\n"
        fi
    fi
done < <(sensors nvme-pci-0100 2>/dev/null)

# Add temperature thresholds info
tooltip+="\\n󰚽 Temperature Thresholds:\\n"
tooltip+=" • CPU: Warning >${CPU_WARNING}°C, Critical >${CPU_CRITICAL}°C\\n"
tooltip+=" • GPU: Warning >${GPU_WARNING}°C, Critical >${GPU_CRITICAL}°C\\n"
tooltip+=" • NVMe: Warning >${NVME_WARNING}°C, Critical >${NVME_CRITICAL}°C\\n"

# Output JSON with status class for CSS styling
echo "{\"text\":\"${status_icon}${cpu_temp_raw}\", \"tooltip\":\"$tooltip\", \"class\":\"$status_class\"}"
