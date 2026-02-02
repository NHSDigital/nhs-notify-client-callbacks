export const handler = async (event: any) => {
  // eslint-disable-next-line no-console
  console.log("RAW EVENT:", JSON.stringify(event, null, 2));

  let parsedEvent: any;
  try {
    parsedEvent = typeof event === "string" ? JSON.parse(event) : event;
  } catch (error) {
    // eslint-disable-next-line no-console
    console.error("Could not parse event string:", error);
    return { body: {} };
  }

  let dataschemaversion: string | undefined;
  let type: string | undefined;

  function findFields(obj: any) {
    if (!obj || typeof obj !== "object") return;
    if (!dataschemaversion && "dataschemaversion" in obj)
      dataschemaversion = obj.dataschemaversion;
    if (!type && "type" in obj) type = obj.type;

    for (const key of Object.keys(obj)) {
      // eslint-disable-next-line security/detect-object-injection
      const val = obj[key];
      if (typeof val === "string") {
        try {
          const nested = JSON.parse(val);
          findFields(nested);
        } catch {
          /* empty */
        }
      } else if (typeof val === "object") {
        findFields(val);
      }
    }
  }

  if (Array.isArray(parsedEvent)) {
    for (const item of parsedEvent) findFields(item);
  } else {
    findFields(parsedEvent);
  }

  if (!dataschemaversion || !type) {
    // eslint-disable-next-line no-console
    console.error("Failed to extract payload from event!");
    return { body: {} };
  }

  return {
    body: {
      dataschemaversion,
      type,
    },
  };
};
