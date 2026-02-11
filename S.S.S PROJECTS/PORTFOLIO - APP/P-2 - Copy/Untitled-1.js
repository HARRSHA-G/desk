import { twMerge } from "tailwind-merge";
// Import the closest Ark UI component if available, or use your custom Frame component
// import { Frame } from "@ark-ui/react"; // If Frame exists in Ark UI
import Frame from "./Frame"; // If you have a custom Frame component

export function ImageFrame({ src, alt }) {
  return (
    <div
      className={twMerge([
        "relative size-90",
        "[--color-frame-1-stroke:var(--color-primary)]/50",
        "[--color-frame-1-fill:var(--color-primary)]/20",
        "[--color-frame-2-stroke:var(--color-accent)]",
        "[--color-frame-2-fill:var(--color-accent)]/20",
        "[--color-frame-3-stroke:var(--color-accent)]",
        "[--color-frame-3-fill:var(--color-accent)]/20",
        "[--color-frame-4-stroke:var(--color-accent)]",
        "[--color-frame-4-fill:var(--color-accent)]/20",
        "[--color-frame-5-stroke:var(--color-primary)]/23",
        "[--color-frame-5-fill:transparent]",
      ])}
    >
      <Frame
        className="drop-shadow-2xl drop-shadow-primary/50"
        paths={["Goodboy.png"]}
      />
      <img
        src={src}
        alt={alt}
        className="absolute inset-0 w-full h-full object-cover rounded"
      />
    </div>
  );
}