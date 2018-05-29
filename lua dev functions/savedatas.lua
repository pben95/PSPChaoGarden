savedatas.lua
-- Uso de SAVES: 
function save() 
mydata = {"nick='LuaDEV'", "age=69", "watermark='Ouch'", "anydata='foo'", "foo='bar'" }; 
mysavedata = mydata:implode("[SEPARATOR_FOR_SEPARE_DATA_XD]");
spaces = { "DATA0", "DATA1", "DATA2" };
saveplace = {gameid="DEMODEV", savenames=spaces};
saveconfig = {title="Sample save of example", subtitle=os.date(), details="Some data saved", savetext="New stuff!"}
done, where = savedata.save(saveplace,saveconfig,mysavedata);
 if done then
  return where
 else
  return nil
 end
end
function load() 
spaces = {"DATA0", "DATA1", "DATA2" };
saveplace = {gameid="DEMODEV", savenames=spaces};
done, where, what = savedata.load(saveplace);
 if done then
  return what:explode("[SEPARATOR_FOR_SEPARE_DATA_XD]");
 else
  return nil
 end;
end
if not save() then
os.message("Not saved. Is any MC? Did you canceled?");
end
data = load();
if data then
 for i=1,#data do
 assert(loadstring(data[i]))(); -- execute lua code, saved in savedata.
 end
end 
os.message("Welcome back, "..nick.."!");
age = age + 1; -- more stuff...
