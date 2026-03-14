#!/bin/bash
# 自动生成日报脚本

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DAILY_REPORTS_DIR="$PROJECT_ROOT/daily-reports"
TEMPLATE_FILE="$DAILY_REPORTS_DIR/TEMPLATE.md"

# 获取日期信息
TODAY=$(date +%Y-%m-%d)
DAY_NUMBER=$(( ($(date -d "$TODAY" +%s) - $(date -d "2026-03-14" +%s)) / 86400 + 1 ))

if [ $DAY_NUMBER -lt 1 ] || [ $DAY_NUMBER -gt 99 ]; then
    echo "错误：日期不在99天挑战范围内"
    exit 1
fi

# 创建日报文件
REPORT_FILE="$DAILY_REPORTS_DIR/$TODAY.md"

if [ -f "$REPORT_FILE" ]; then
    echo "今日日报已存在：$REPORT_FILE"
    echo "请直接编辑该文件"
    exit 0
fi

# 从模板生成
cp "$TEMPLATE_FILE" "$REPORT_FILE"

# 替换日期信息
sed -i "s/YYYY-MM-DD/$TODAY/g" "$REPORT_FILE"
sed -i "s/第X天\/99/第${DAY_NUMBER}天\/99/g" "$REPORT_FILE"

# 设置值班人员（简单轮值：虎→虾→蟹→刀）
ROTATION=("王虎 🐯" "王大虾 🦐" "王小蟹 🦀" "王大刀 🔪")
ROTATION_INDEX=$(( ($DAY_NUMBER - 1) % 4 ))
TODAY_MANAGER="${ROTATION[$ROTATION_INDEX]}"

sed -i "s/今日值班：.*/今日值班：$TODAY_MANAGER/" "$REPORT_FILE"

echo "✅ 日报已生成：$REPORT_FILE"
echo "📅 第 ${DAY_NUMBER} 天 / 99"
echo "👤 今日值班：$TODAY_MANAGER"
echo "⏰ 请于21:00前完成内容填写并提交"