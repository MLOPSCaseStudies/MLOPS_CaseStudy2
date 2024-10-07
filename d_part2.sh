PORT=22011
MACHINE=paffenroth-23.dyn.wpi.edu

cd tmp

COMMAND="ssh -i student-admin_key -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE}"

${COMMAND} "ls CS553CaseStudy1"
${COMMAND} "sudo apt install python3-venv"
${COMMAND} "cd CS553CaseStudy1 && python3 -m venv venv"
${COMMAND} "cd CS553CaseStudy1 && ./venv/bin/python3 -m pip install -r requirements.txt"

# ${COMMAND} "cd CS553CaseStudy1 && nohup ./venv/bin/python3 app.py > log.txt 2>&1 &"

${COMMAND} "nohup CS553CaseStudy1/venv/bin/python CS553CaseStudy1/app.py > log.txt 2>&1 &"

