const months = ['January','February','March','April','May','June','July',
               'August','September','October','November','December']
const d = new Date()
d.setDate(d.getDate() + parseInt(DAYS))
output.target = `${String(d.getDate()).padStart(2, '0')} ${months[d.getMonth()]} ${d.getFullYear()}`
console.log('target=' + output.target)
output.expected = `${String(d.getMonth() + 1).padStart(2, '0')}/${String(d.getDate()).padStart(2, '0')}/${d.getFullYear()}`
